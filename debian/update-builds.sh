#!/bin/sh

main() {
    init
    bash make_dockerfile
    DIST=debian
    case "$1" in
    debian ) DIST=debian; shift ;;
    ubuntu ) DIST=ubuntu; shift ;;
    sid-x32 )
	DIST=debian
	do_build "$1" "$DIST" \
	    '--no-check-gpg\ --include=debian-ports-archive-keyring' \
	    http://ftp.ports.debian.org/debian-ports
	exit
	;;
    esac

    if [ "$#" -gt 0 ]
    then
	for fullvar
	do do_build "$fullvar" $DIST
	done
    elif [ "$DIST" = debian ]
    then all_debian
    elif [ "$DIST" = ubuntu ]
    then all_ubuntu
    else echo >&2 "Nothing to do" ; exit 1
    fi
}

all_debian() {
    # potato doesn't build on "Docker hub".

    for fullvar in \
	woody sarge etch lenny squeeze wheezy \
	jessie stretch buster bullseye \
	stable testing unstable latest \
	\
	etch-i386 lenny-i386 squeeze-i386 wheezy-i386 \
	jessie-i386 stretch-i386 buster-i386 bullseye-i386 \
	unstable-i386
    do do_build "$fullvar" debian
    done
}

all_ubuntu() {
    for fullvar in \
	warty hoary breezy dapper edgy feisty gutsy hardy intrepid \
	jaunty karmic lucid maverick natty oneiric precise \
	quantal raring saucy trusty utopic vivid wily xenial \
	yakkety zesty artful bionic cosmic disco eoan focal groovy \
	\
	breezy-i386 dapper-i386 edgy-i386 feisty-i386 gutsy-i386 \
	hardy-i386 intrepid-i386 jaunty-i386 karmic-i386 lucid-i386 \
	maverick-i386 natty-i386 oneiric-i386 precise-i386 quantal-i386 \
	raring-i386 saucy-i386 trusty-i386 utopic-i386 vivid-i386 \
	wily-i386 xenial-i386 yakkety-i386 zesty-i386 artful-i386 \
	bionic-i386 cosmic-i386 disco-i386 eoan-i386

    do do_build "$fullvar" ubuntu
    done
}

do_build() {
    distro="$2"
    fullvar="$1"
    variant=${fullvar%-*}; arch=${fullvar#$variant}; arch="${arch#-}"

    b="build-$distro-$variant${arch:+-$arch}"

    echo "#### Starting $b"

    git worktree remove -f "$T" 2>/dev/null ||:
    git update-ref refs/tempref "$NULL"
    git worktree add "$T" "$NULL"

    (
	set -e
	cd "$T"
	git checkout "$b" ||:

	if [ "$variant" = latest ]
	then dvar=stable
	else dvar="$variant"
	fi

	cp -p ../Dockerfile Dockerfile
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

	cp -p Dockerfile ../Dockerfile.tmp

	if [ "$distro" = debian ]
	then cp -p ../README.md README.md
	else cp -p ../README-Generic.md README.md
	fi

	ID=$(docker image inspect --format '{{.Id}}' "rdebath/$distro:$fullvar" 2>/dev/null ||:)
	if [ "$ID" = '' ]
	then
	    docker build -t "rdebath/$distro:$fullvar" -<Dockerfile
	    ID=$(docker image inspect --format '{{.Id}}' "rdebath/$distro:$fullvar")
	fi

	cat packages.txt > savedpackages.txt ||:
	rm -f packages.txt
	case "$fullvar" in
	potato|dapper|dapper-i386)
	    UPCMD=upgrade ;;
	* ) UPCMD=dist-upgrade ;;
	esac
	case "$arch" in
	i386 ) DOCKERSECOPT="$DOCKERI386" ;;
	* )    DOCKERSECOPT='' ;;
	esac

	docker run $DOCKERSECOPT --rm -t -v "$(pwd)":/home/user \
	    "rdebath/$distro:$fullvar" \
	    bash -c "echo 'Checking for upgraded packages' &&
		dpkg -l > /home/user/packages-before.txt &&
		rm -f /home/user/packages.txt &&
		apt-get -y -qq update &&
		apt-get -y $UPCMD &&
		dpkg -l > /home/user/packages.txt ||:"

	if ! cmp savedpackages.txt packages.txt
	then
	    [ -s packages.txt ] &&
		mktag "$b" "Update build tree for $fullvar"
	fi
	if ! cmp packages-before.txt packages.txt
	then
	    [ -s packages.txt ] || date > packages.txt

	    sed -i -e 's;^\(ARG STAMP\>\).*;\1="'"$( \
		md5sum < packages.txt | awk '{print $1;}')"'";' \
		Dockerfile

	    docker build -t "rdebath/$distro:$fullvar" -<Dockerfile
	fi
    )
    git update-ref -d refs/tempref
    git worktree remove -f "$T" ||:
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

    NULL=$(echo "tree $(git hash-object -t tree -w /dev/null)
author nobody <> 1 +0000
committer nobody <> 1 +0000

 
" | git hash-object -t commit -w --stdin )

    T="$(pwd)/temptree"

    DOCKERI386='--security-opt seccomp:unconfined'
}

main "$@"
