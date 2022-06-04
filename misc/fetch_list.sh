#!/usr/bin/env bash
# shellcheck disable=SC1003,SC2001
if [ -z "$BASH_VERSION" ];then exec bash "$0" "$@";else set +o posix;fi
set -e

main() {

	for base in \
	    alpine debian:buster ubuntu:latest centos:latest fedora:latest \
	    opensuse/leap opensuse/tumbleweed archlinux \
	    \
	    debian:unstable debian:testing ubuntu:16.04 \
	    \
	    debian:stretch debian:jessie debian:squeeze debian:wheezy \
	    i386/debian:jessie i386/debian:wheezy jfcoz/lenny:latest

	do fetch_one $base
	done
}

fetch_one() {
    I=$(echo "$1"-bf | tr ':/' '--' | tr -d . | \
	sed -e 's/-latest-/-/' \
	    -e 's/^debian-/deb-/' \
	    -e 's/i386-debian/deb-i386/' )

    echo Fetching "$I"
    ssh root@dell6330a "docker image save '$I' | pigz " | pv |
    gzip -d | docker image load

}

main "$@"
