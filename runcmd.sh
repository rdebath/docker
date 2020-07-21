#!/bin/bash

main() {
    case "$1" in
    '' ) make_docker_runcmd "$0" '' start ;;
    start) guest_start; exit;;

    -u ) shift ; cat "$@" | grep ^_ | base64 -di | gzip -d ;;

    -x ) shift
	sn="/tmp/install"
	echo "RUN (\\"
	cat "$@" |
	    while IFS= read -r line
	    do echo echo "${line@Q};\\"
	    done
	echo ")>$sn;sh -e $sn;rm -f $sn"
	exit
	;;

    * ) make_docker_runcmd "$@" ;;
    esac
}

################################################################################
# Simple routine to embed a nice scriptfile into a RUN command.

make_docker_runcmd() {
    # Limit per "run" is library exec arg length (approx 128k)
    script="$1" ; sname="${2:-/tmp/install}"
    echo 'RUN set -eu;_() { echo "$@";};'"(\\"
    gzip -cn9 "$script" | base64 -w 72 | sed 's/.*/_ &;\\/'
    echo ")|base64 -d|gzip -d>$sname;sh -e $sname${3:+ $3};rm -f $sname"
}

main "$@"
