#!/bin/sh

NULL=$(echo "tree $(git hash-object -t tree -w /dev/null)
author nobody <> 1 +0000
committer nobody <> 1 +0000

 
" | git hash-object -t commit -w --stdin )

T="$(pwd)/temptree"

for variant in \
    potato woody sarge etch lenny squeeze wheezy \
    jessie stretch buster bullseye unstable
do
    b="build-$variant"
    git worktree add "$T" "$NULL"

    (
	set -e
	cd "$T"
	git checkout "$b" 2>/dev/null ||
	    git checkout --orphan "$b"

	sed -e 's/^\(ARG RELEASE\>\).*/\1='"$variant"'/' \
	    < ../Dockerfile > Dockerfile

	cp -p ../README.txt .

	case "$variant" in
	potato )
	    sed -i -e 's@^\(ARG DEBOPTIONS\>\).*@\1=--no-check-gpg@' \
		Dockerfile
	    ;;
	wheezy )
	    sed -i -e 's@^\(ARG MIRROR\>\).*@\1=http://archive.debian.org/debian@' \
		Dockerfile
	    ;;
	esac

	ID=$(docker image inspect --format '{{.Id}}' rdebath/debian:$variant 2>/dev/null ||:)
	if [ "$ID" = '' ]
	then
	    docker build -t rdebath/debian:$variant -<Dockerfile
	    ID=$(docker image inspect --format '{{.Id}}' rdebath/debian:$variant)
	fi

	docker run --rm -it -v "$(pwd)":/home/user \
	    rdebath/debian:$variant \
	    bash -c 'apt-get update && apt-get -y dist-upgrade && dpkg -l > /home/user/packages.txt'

	git add -A
	git commit -m "Update build tree for $variant"
    )
    git worktree remove "$T"

done
