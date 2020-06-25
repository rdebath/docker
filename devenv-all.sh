#!/usr/bin/env bash
if [ ! -n "$BASH_VERSION" ];then if [ "`which 2>/dev/null bash`" != "" ];then exec bash "$0" "$@"; fi ; fi

set -e

doit() {
    I=$(echo "$1"-bf | tr ':/' '--' | tr -d . | \
	sed -e 's/-latest-/-/' \
	    -e 's/^debian-/deb-/' \
	    -e 's/i386-debian/deb-i386/' )

    case "$1" in
    *suse* ) 
        DFILE=$(./build.sh devenv.sh | sed '/^FROM.*/d')
	DFILE=$(
	    echo "FROM $1"
	    echo 'RUN [ -e /bin/gzip ] || { [ -e /usr/bin/zypper ] && { \'
	    echo 'echo >&2 WARNING: gzip not installed in SUSE -- WTF ; \'
	    echo 'zypper install -y gzip ; zypper clean -a ; } ; }'
	    echo "$DFILE"
	)

	;;
    * ) DFILE=$(./build.sh devenv.sh | sed 's;^FROM.*;FROM '"$1"';') ;;
    esac

    echo "build $1 -> $I"
    echo "$DFILE" | docker build - -t "$I" &

    cnt=$((cnt + 1))
    if [ "$cnt" -gt 3 ]
    then wait -n ; cnt=$((cnt - 1))
    fi
}

# doit archlinux ; wait ; exit

for base in \
    debian:buster debian:jessie debian:squeeze debian:stretch \
    debian:testing debian:unstable debian:wheezy i386/debian:jessie \
    i386/debian:wheezy jfcoz/lenny:latest ubuntu:16.04 ubuntu:latest \
    alpine centos:latest fedora:latest opensuse/leap opensuse/tumbleweed \
    archlinux
do doit $base
done

wait ; exit
