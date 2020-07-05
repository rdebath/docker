#!/bin/sh

NULL=$(echo "tree $(git hash-object -t tree -w /dev/null)
author nobody <> 1 +0000
committer nobody <> 1 +0000

 
" | git hash-object -t commit -w --stdin )

T="$(pwd)/temptree"

for variant in \
    potato woody sarge etch lenny squeeze wheezy \
    jessie stretch buster bullseye unstable stable
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

	git add -A
	git commit -m "Update build tree for $variant"
    )
    git worktree remove "$T"

done