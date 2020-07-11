#!/bin/sh

main() {
    init

    bash make_dockerfile

    # potato doesn't build on "Docker hub".

    [ "$#" = 0 ] && set -- \
	woody sarge etch lenny squeeze wheezy \
	jessie stretch buster bullseye \
	stable testing unstable latest \
	\
	etch-i386 lenny-i386 squeeze-i386 wheezy-i386 \
	jessie-i386 stretch-i386 buster-i386 bullseye-i386

    for fullvar
    do do_build "$fullvar" debian
    done
}

do_build() {
    distro="$2"
    fullvar="$1"
    variant=${fullvar%-*}; arch=${fullvar#$variant}; arch="${arch#-}"

    b="build-$distro-$variant${arch:+-$arch}"

    git worktree remove -f "$T" 2>/dev/null ||:
    git worktree add "$T" "$NULL"

    (
	set -e
	cd "$T"
	git branch -D "$b" 2>/dev/null ||:
	git checkout -b "$b" --track origin/"$b" 2>/dev/null ||
	    git checkout -f --orphan "$b"

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

	cp -p ../README.md .

	ID=$(docker image inspect --format '{{.Id}}' "rdebath/debian:$fullvar" 2>/dev/null ||:)
	if [ "$ID" = '' ]
	then
	    docker build -t "rdebath/debian:$fullvar" -<Dockerfile
	    ID=$(docker image inspect --format '{{.Id}}' "rdebath/debian:$fullvar")
	fi

	cat packages.txt > /tmp/_savedpackages.txt ||:
	rm -f packages.txt
	docker run --rm -t -v "$(pwd)":/home/user \
	    "rdebath/debian:$fullvar" \
	    bash -c 'apt-get -y -qq update &&
		apt-get -y upgrade &&
		dpkg -l > /home/user/packages.txt'

	if ! cmp /tmp/_savedpackages.txt packages.txt
	then
	    docker build -t "rdebath/debian:$fullvar" -<Dockerfile

	    docker run --rm -t -v "$(pwd)":/home/user \
		"rdebath/debian:$fullvar" \
		bash -c 'apt-get -y -qq update &&
		    apt-get -y upgrade &&
		    dpkg -l > /home/user/packages.txt'

	    git add -A
	    git commit -m "Update build tree for $fullvar"
	    git push origin "$b"
	fi
	rm -f /tmp/_savedpackages.txt
    )
    git worktree remove -f "$T" ||:
    git branch -D "$b" ||:
}

init() {
    set -e

    NULL=$(echo "tree $(git hash-object -t tree -w /dev/null)
author nobody <> 1 +0000
committer nobody <> 1 +0000

 
" | git hash-object -t commit -w --stdin )

    T="$(pwd)/temptree"
}

main "$@"
