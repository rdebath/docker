#!/bin/bash -
set -e

cd "$(dirname "$0")"

TAGS="buster bullseye bookworm trixie sid sid-x32"
./make_images $TAGS

for i in $(docker images reg.xz/*:* --format='{{.Repository}}:{{.Tag}}' |
    grep -v '<')
do echo "Pushing $i"
   docker push "$i"
done

for i in \
    buster bullseye bookworm trixie testing sid unstable stable latest
do
    docker push rdebath/debian:$i reg.xz/debian:$i
    docker push rdebath/debian-i386:$i reg.xz/debian-i386:$i
done

docker push rdebath/debian:sid-x32 reg.xz/debian-x32:sid

