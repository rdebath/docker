#!/bin/bash -
set -e

cd "$(dirname "$0")"

TAGS="buster bullseye bookworm trixie sid"
./make_images $TAGS sid-x32

for i in $(docker images reg.xz/*:* --format='{{.Repository}}:{{.Tag}}' |
    grep -v '<')
do echo "Pushing $i"
   docker push "$i"
done

pushit() {
    echo "Push ${2}"
    docker push rdebath/debian:$2 reg.xz/debian:$1
    echo "Push ${2}-386"
    docker push rdebath/debian-i386:$2 reg.xz/debian:${1}-i386
}

for i in $TAGS
do pushit $i $i
done

pushit bookworm stable
pushit trixie testing
pushit sid unstable

docker push rdebath/debian:sid-x32 reg.xz/debian-x32:sid

pushit bookworm latest
