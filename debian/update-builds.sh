#!/bin/sh
# shellcheck disable=SC2086

# TODO:
#  From make_image
#    Option -j
#    Option for docker push to private repo.

main() {
    init
    TAGS=""
    DIST=debian

    while [ "$#" -gt 0 ]
    do
	[ "$1" = -f ] && { FORCEBUILD=1 ; shift ; }
	[ "$1" = -P ] && { FORCEBUILD=1 ; FORCEPUSH=1 ; shift ; }
	[ "$1" = -p ] && { FORCEPUSH=1 ; shift ; }
	[ "$1" = -n ] && { NOPUSH=1 ; shift ; }

	# shellcheck disable=SC2086
	case "$1" in
	i386 ) shift ; DEFAULT_ARCH=i386 ;;

	debian|ubuntu|devuan|kali ) DIST=$1; shift ;;

	ubuntu1 ) shift ; set -- $UBUNTU1 ;;
	ubuntu2 ) shift ; set -- $UBUNTU2 ;;
	ubuntu3 ) shift ; set -- $UBUNTU3 ;;
	ubuntu4 ) shift ; set -- $UBUNTU4 ;;
	ubuntu5 ) shift ; set -- $UBUNTU5 ;;
	ubuntults ) shift ; set -- $UBUNTULTS ;;

	* ) TAGS="${TAGS:+$TAGS }$1"; shift ;;
	esac
    done

    [ "$TAGS" = all ] && { all_dists; exit; }

    set -f ; set -- $TAGS ; set +f

    if [ "$#" -gt 0 ]
    then
	for fullvar
	do
	    case "$fullvar" in
	    sid-x32 )
		DIST=debian
		do_build "$1" "$DIST" \
		    '--no-check-gpg\ --include=debian-ports-archive-keyring' \
		    http://ftp.ports.debian.org/debian-ports
		;;
	    *)  choose_distro "$fullvar"
		do_build "$fullvar" $DIST
		;;
	    esac
	done

    elif [ "$DIST" = debian ]
    then all_debian
    elif [ "$DIST" = devuan ]
    then all_devuan
    elif [ "$DIST" = kali ]
    then all_kali
    elif [ "$DIST" = ubuntu ]
    then all_ubuntu
    else echo >&2 "Nothing to do" ; exit 1
    fi
}

all_dists() {
    for DEFAULT_ARCH in '' i386
    do all_debian ; all_devuan ; all_kali
    done

    for DEFAULT_ARCH in '' i386
    do all_ubuntu
    done

    DEFAULT_ARCH=
    do_build amber pureos ||:
}

all_debian() {
    # Note: potato doesn't build on "Docker hub".
    for fullvar in \
	potato woody sarge \
	etch lenny squeeze wheezy jessie stretch buster bullseye \
	stable

    do do_build "$fullvar" debian ||:
    done

    [ "$DEFAULT_ARCH" = i386 ] || {
	do_build testing debian ||:
	do_build unstable debian ||:
    }
}

all_devuan() {
    for fullvar in jessie ascii beowulf chimaera ceres
    do do_build "$fullvar" devuan ||:
    done
}

all_kali() {
    for fullvar in kali_rolling kali_last_snapshot kali_dev
    do do_build "$fullvar" kali ||:
    done
}

all_ubuntu() {
    for fullvar in $UBUNTU1 $UBUNTU2 $UBUNTU3 $UBUNTU4 $UBUNTU5
    do do_build "$fullvar" ubuntu ||:
    done
}

do_build() {
    distro="$2"
    relname="$1"
    variant=${relname%-*}; arch=${relname#$variant}; arch="${arch#-}"
    relname="$(echo "$relname" | tr _ -)"
    variant="$(echo "$variant" | tr _ -)"
    arch="${arch:-$DEFAULT_ARCH}"
    release="$REGISTRY$distro${arch:+-$arch}:$variant"

    b="build/$distro${arch:+-$arch}+$variant"
    # /^build\/debian-i386\+(.*)$/  {\1}

    echo "#### Starting $release"

    git worktree remove -f "$T" 2>/dev/null ||:
    git update-ref refs/tempref "$NULL"
    git worktree add "$T" "$NULL"

    (
	set -e
	P="$(pwd)"
	cd "$T"
	git checkout "$b" ||:

	if [ "$variant" = latest ]
	then dvar=unstable
	else dvar="$variant"
	fi
	if [ "$dvar" = jessie ]&&[ "$distro" = devuan ]
	then dvar="$dvar:$distro"
	fi

	( cd "$P" ; bash make_dockerfile - ) > Dockerfile

	sed -i -e 's/^\(ARG RELEASE\>\).*/\1='"$dvar"'/' \
	    Dockerfile

	[ "$arch" != '' ] && {
	    sed -i -e 's/^\(ARG ARCH\>\).*/\1='"$arch"'/' \
		Dockerfile
	}

	[ "$3" != '' ] &&
	    sed -i -e 's;^\(ARG DEBOPTIONS\>\).*;\1="'"$3"'";' \
		Dockerfile

	[ "$4" != '' ] &&
	    sed -i -e 's;^\(ARG MIRROR\>\).*;\1="'"$4"'";' \
		Dockerfile

	[ "$5" != '' ] &&
	    sed -i -e 's;^\(ARG DEBSCRIPT\>\).*;\1="'"$5"'";' \
		Dockerfile

	cp -p Dockerfile "$P"/Dockerfile.tmp

	if [ "$distro" = debian ]
	then cp -p "$P"/README.md README.md
	else cp -p "$P"/README-Generic.md README.md
	fi

	ID=$(docker image inspect --format '{{.Id}}' "$release" 2>/dev/null ||:)
	if [ "$ID" = '' ]||[ "$FORCEBUILD" = 1 ]
	then
	    docker build -t "$release" -<Dockerfile
	    ID=$(docker image inspect --format '{{.Id}}' "$release")
	fi

	if [ "$FORCEBUILD" != 1 ] || [ "$NOPUSH" != 1 ]
	then
	    :>> packages.txt
	    cat packages.txt > savedpackages.txt
	    [ "$FORCEPUSH" = 1 ] && :> savedpackages.txt

	    case "$variant" in
	    dapper|dapper-i386)
		UPCMD=upgrade ;;
	    * ) UPCMD=dist-upgrade ;;
	    esac

	    case "$arch" in
	    i386 ) DOCKERSECOPT="$DOCKERI386" ;;
	    * )    DOCKERSECOPT='' ;;
	    esac

	    cat > test_state.sh <<-!
		echo 'Checking for upgraded packages'
		ulimit -n 1024
		dpkg -l > /home/user/packages-before.txt
		rm -f /home/user/packages.txt
		apt-get -y -qq update
		apt-get -y $UPCMD
		dpkg -l > /home/user/packages.txt
		!

	    docker run $DOCKERSECOPT --rm -t -v "$(pwd)":/home/user \
		"$release" \
		bash /home/user/test_state.sh

	    if ! cmp -s savedpackages.txt packages.txt
	    then
		[ -s packages.txt ] && {
		    if [ "$NOPUSH" != 1 ]
		    then mktag "$b" "Update build tree for $release"
		    else
			echo "# Tag '$b' needs to be pushed."
			# diff savedpackages.txt packages.txt
		    fi
		}
	    fi
	    if ! cmp -s packages-before.txt packages.txt
	    then
		[ -s packages.txt ] || date > packages.txt

		sed -i -e '/^ARG RELEASE\>/a ARG STAMP="'"$( \
		    md5sum < packages.txt | awk '{print $1;}')"'"' \
		    Dockerfile

		docker build -t "$release" -<Dockerfile
	    fi
	fi
    )
    git update-ref -d refs/tempref
    git worktree remove -f "$T" ||:
    echo "#### Done $release"
}

choose_distro() {
    case "${1%-*}" in
    stable|testing|unstable )
	DIST=debian ;;

    jessie )
	[ "$DIST" != debian ]&&[ "$DIST" != devuan ] &&
	    DIST=debian
	;;

    potato|woody|sarge|etch|lenny|squeeze|wheezy )
	DIST=debian ;;
    stretch|buster|bullseye|bookworm)
	DIST=debian ;;

    kali_rolling|kali_last_snapshot|kali_dev )
	DIST=kali ;;
    ascii|beowulf|chimaera|ceres )
	DIST=devuan ;;

    dapper|hardy|lucid|precise|trusty|xenial|bionic|focal ) # LTS
	DIST=ubuntu ;;
    warty|hoary|breezy|edgy|feisty|gutsy|intrepid|jaunty|karmic|maverick )
	DIST=ubuntu ;;
    natty|oneiric|quantal|raring|saucy|utopic|vivid|wily|yakkety|zesty )
	DIST=ubuntu ;;
    artful|cosmic|disco|eoan|groovy )
	DIST=ubuntu ;;

    amber ) DIST=pureos ;;

    aequorea|bartholomea|chromodoris|dasyatis)
	DIST=tanglu ;;
    esac
    :
}

mktag() {
    TAG="$1"
    TAB=$(echo .|tr . '\011')

    git update-ref refs/tags/"$TAG" "$(
    {
	echo "100644 blob $(git hash-object -w Dockerfile )${TAB}Dockerfile"
	echo "100644 blob $(git hash-object -w README.md)${TAB}README.md"
	echo "100644 blob $(git hash-object -w packages.txt )${TAB}packages.txt"

    } | {
	echo "tree $(git mktree)"
	echo "author Autopost <> $(date +%s) +0000"
	echo "committer Autopost <> $(date +%s) +0000"
	echo
	echo "$2"
	echo
	echo '👻'
    } | git hash-object -t commit -w --stdin )"

    git push -f origin "$TAG"
}

init() {
    set -e

    REGISTRY=reg.xz/

    NULL=$(echo "tree $(git hash-object -t tree -w /dev/null)
author nobody <> 1 +0000
committer nobody <> 1 +0000

 
" | git hash-object -t commit -w --stdin )

    T="$(pwd)/temptree"

    DOCKERI386=''
    # '--security-opt seccomp:unconfined'

    UBUNTU1='warty hoary breezy dapper edgy feisty gutsy hardy intrepid'
    UBUNTU2='jaunty karmic lucid maverick natty oneiric precise'
    UBUNTU3='quantal raring saucy trusty utopic vivid wily'
    UBUNTU4='xenial yakkety zesty artful bionic cosmic disco'
    UBUNTU5='eoan focal groovy'

    UBUNTULTS='dapper hardy lucid precise trusty xenial bionic focal'
}

main "$@"

#   Uncompilable combinations.
#
# Not compiled for i386
# [ "$RELEASE" = amber -a "$ARCH" = i386 ] && continue # Missing
#
# Only compiled for i386 and has inode number issue
# [ "$RELEASE" = potato -a "$ARCH" = i386 ] && continue # Is default
#
# Only compiled for i386
# [ "$RELEASE" = woody -a "$ARCH" = i386 ] && continue # Is default
# [ "$RELEASE" = sarge -a "$ARCH" = i386 ] && continue # Is default
#
# These fail if host libseccomp2 < 2.4.3-1+b1
# [ "$RELEASE" = unstable -a "$ARCH" = i386 ] && continue
# [ "$RELEASE" = focal -a "$ARCH" = i386 ] && continue
# [ "$RELEASE" = groovy -a "$ARCH" = i386 ] && continue
#
# i386 vdso needs to be at fixed address.
# [ "$RELEASE" = warty -a "$ARCH" = i386 ] && continue
# [ "$RELEASE" = hoary -a "$ARCH" = i386 ] && continue
