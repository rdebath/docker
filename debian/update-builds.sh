#!/bin/sh

# TODO:
#  From make_image
#    Option -j
#    Option for docker push to private repo.

#   Uncompiled combinations.
#
# Not compiled for i386
# [ "$RELEASE" = amber -a "$ARCH" = i386 ] && continue # Missing

# Only compiled for i386 and has inode number issue
# [ "$RELEASE" = potato -a "$ARCH" = i386 ] && continue # Is default

# Only compiled for i386
# [ "$RELEASE" = woody -a "$ARCH" = i386 ] && continue # Is default
# [ "$RELEASE" = sarge -a "$ARCH" = i386 ] && continue # Is default

# These fail if libseccomp2 < 2.4.3-1+b1
# [ "$RELEASE" = unstable -a "$ARCH" = i386 ] && continue
# [ "$RELEASE" = focal -a "$ARCH" = i386 ] && continue
# [ "$RELEASE" = groovy -a "$ARCH" = i386 ] && continue

# i386 vdso needs to be at fixed address.
# [ "$RELEASE" = warty -a "$ARCH" = i386 ] && continue
# [ "$RELEASE" = hoary -a "$ARCH" = i386 ] && continue

main() {
    init

    [ "$1" = -f ] && { FORCEBUILD=1 ; shift ; }
    [ "$1" = -P ] && { FORCEBUILD=1 ; FORCEPUSH=1 ; shift ; }
    [ "$1" = -p ] && { FORCEPUSH=1 ; shift ; }
    [ "$1" = -n ] && { NOPUSH=1 ; shift ; }

    # shellcheck disable=SC2086
    case "$1" in
    debian|ubuntu|devuan|kali ) DIST=$1; shift ;;

    ubuntu1 ) shift ; set -- $UBUNTU1 ;;
    ubuntu2 ) shift ; set -- $UBUNTU2 ;;
    ubuntu3 ) shift ; set -- $UBUNTU3 ;;
    ubuntu4 ) shift ; set -- $UBUNTU4 ;;
    ubuntu5 ) shift ; set -- $UBUNTU5 ;;

    * ) DIST=debian ;;
    esac

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
    elif [ "$DIST" = ubuntu ]
    then all_ubuntu
    else echo >&2 "Nothing to do" ; exit 1
    fi
}

all_debian() {
    # Note: potato doesn't build on "Docker hub".

    for fullvar in \
	potato woody sarge \
	etch-i386   etch   lenny-i386    lenny  squeeze-i386 squeeze \
	wheezy-i386 wheezy jessie-i386   jessie stretch-i386 stretch \
	buster-i386 buster bullseye-i386 bullseye \
	\
	stable-i386 stable testing-i386  testing \
	unstable-i386 unstable latest

    do do_build "$fullvar" debian
    done
}

all_devuan() {
    for fullvar in \
	jessie ascii beowulf chimaera ceres \
	jessie-i386 ascii-i386 beowulf-i386 chimaera-i386 ceres-i386
    do do_build "$fullvar" devuan
    done
}

all_ubuntu() {
    for fullvar in $UBUNTU1 $UBUNTU2 $UBUNTU3 $UBUNTU4 $UBUNTU5
    do do_build "$fullvar" ubuntu
    done
}

do_build() {
    distro="$2"
    fullvar="$1"
    variant=${fullvar%-*}; arch=${fullvar#$variant}; arch="${arch#-}"
    fullvar="$(echo "$fullvar" | tr _ -)"
    variant="$(echo "$variant" | tr _ -)"

    b="build-$distro-$variant${arch:+-$arch}"

    echo "#### Starting $b"

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

	ID=$(docker image inspect --format '{{.Id}}' "$REGISTRY$distro:$fullvar" 2>/dev/null ||:)
	if [ "$ID" = '' ]||[ "$FORCEBUILD" = 1 ]
	then
	    docker build -t "$REGISTRY$distro:$fullvar" -<Dockerfile
	    ID=$(docker image inspect --format '{{.Id}}' "$REGISTRY$distro:$fullvar")
	fi

	if [ "$FORCEBUILD" != 1 ] || [ "$NOPUSH" != 1 ]
	then
	    :>> packages.txt
	    cat packages.txt > savedpackages.txt
	    [ "$FORCEPUSH" = 1 ] && :> savedpackages.txt

	    case "$fullvar" in
	    dapper|dapper-i386)
		UPCMD=upgrade ;;
	    * ) UPCMD=dist-upgrade ;;
	    esac
	    case "$arch" in
	    i386 ) DOCKERSECOPT="$DOCKERI386" ;;
	    * )    DOCKERSECOPT='' ;;
	    esac

	    docker run $DOCKERSECOPT --rm -t -v "$(pwd)":/home/user \
		"$REGISTRY$distro:$fullvar" \
		bash -c "echo 'Checking for upgraded packages' ;\
		    ulimit -n 1024 ||:;\
		    dpkg -l > /home/user/packages-before.txt &&
		    rm -f /home/user/packages.txt &&
		    apt-get -y -qq update &&
		    apt-get -y $UPCMD &&
		    dpkg -l > /home/user/packages.txt ||:"

	    if ! cmp -s savedpackages.txt packages.txt
	    then
		[ -s packages.txt ] &&
		    [ "$NOPUSH" != 1 ] &&
			mktag "$b" "Update build tree for $fullvar"
	    fi
	    if ! cmp -s packages-before.txt packages.txt
	    then
		[ -s packages.txt ] || date > packages.txt

		sed -i -e '/^ARG RELEASE\>/a ARG STAMP="'"$( \
		    md5sum < packages.txt | awk '{print $1;}')"'"' \
		    Dockerfile

		docker build -t "$REGISTRY$distro:$fullvar" -<Dockerfile
	    fi
	fi
    )
    git update-ref -d refs/tempref
    git worktree remove -f "$T" ||:
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

    REGISTRY=rdebath/

    NULL=$(echo "tree $(git hash-object -t tree -w /dev/null)
author nobody <> 1 +0000
committer nobody <> 1 +0000

 
" | git hash-object -t commit -w --stdin )

    T="$(pwd)/temptree"

    DOCKERI386=''
    # '--security-opt seccomp:unconfined'

UBUNTU1='warty hoary breezy-i386 breezy dapper-i386 dapper edgy-i386 edgy
feisty-i386 feisty gutsy-i386 gutsy hardy-i386 hardy intrepid-i386 intrepid'

UBUNTU2='jaunty-i386 jaunty karmic-i386 karmic lucid-i386 lucid maverick-i386
maverick natty-i386 natty oneiric-i386 oneiric precise-i386 precise'

UBUNTU3='quantal-i386 quantal raring-i386 raring saucy-i386 saucy trusty-i386
trusty utopic-i386 utopic vivid-i386 vivid wily-i386 wily'

UBUNTU4='xenial-i386 xenial yakkety-i386 yakkety zesty-i386 zesty artful-i386
artful bionic-i386 bionic cosmic-i386 cosmic disco-i386 disco'

UBUNTU5='eoan-i386 eoan focal-i386 focal groovy-i386 groovy'
}

main "$@"
