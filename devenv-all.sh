#!/usr/bin/env bash
if [ ! -n "$BASH_VERSION" ];then if [ "`which 2>/dev/null bash`" != "" ];then exec bash "$0" "$@"; fi ; fi

set -e

doit() {
    I=$(echo "$1"-bf | tr ':/' '--' | tr -d . | \
	sed -e 's/-latest-/-/' \
	    -e 's/^debian-/deb-/' \
	    -e 's/i386-debian/deb-i386/' )

    ./build.sh devenv.sh | sed 's;^FROM.*;FROM '"$1"';' |
	docker build - -t "$I" &

    cnt=$((cnt + 1))
    if [ "$cnt" -gt 3 ]
    then wait -n ; cnt=$((cnt - 1))
    fi
}

doit alpine
doit centos:latest
doit debian:buster
doit debian:jessie
doit debian:squeeze
doit debian:stretch
doit debian:testing
doit debian:unstable
doit debian:wheezy
doit fedora:latest
doit i386/debian:jessie
doit i386/debian:wheezy
doit ubuntu:16.04
doit ubuntu:latest
wait
