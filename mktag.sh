#!/bin/sh

SCRIPT="$1"
TAG="$2"
shift 2
COMMENT="$*"
TAB=$(echo .|tr . '\011')
git update-ref refs/tags/"$TAG" "$(
{
    [ "$COMMENT" != '' ] && {
	echo "$COMMENT" |
	echo "100644 blob $(git hash-object -w --stdin)${TAB}README.md"
    }

    bash build.sh "$SCRIPT" |
    echo "100644 blob $(git hash-object -w --stdin)${TAB}Dockerfile"

} | {
echo "tree $(git mktree)
author Autopost <> $(date +%s) +0000
committer Autopost <> $(date +%s) +0000

👻
" ; } | git hash-object -t commit -w --stdin )"

git push -f origin "$TAG"

