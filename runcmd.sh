#!/bin/bash

################################################################################
# Simple routine to embed a nice scriptfile into a RUN command.

make_docker_runcmd() {
    # Limit per "run" is library exec arg length (approx 128k)
    script="$1" ; sname="${2:-/tmp/install}"
    echo 'RUN set -eu;_() { echo "$@";};'"(\\"
    gzip -cn9 "$script" | base64 -w 72 | sed 's/.*/_ &;\\/'
    echo ")|base64 -d|gzip -d>$sname;sh -ex $sname;rm -f $sname"
}

make_docker_runtxt() {
    sn="/tmp/install"
    echo "RUN (\\"
    cat "$@" |
	while IFS= read -r line
	do echo echo "${line@Q};"\\
	done
    echo ")>$sn;sh -e $sn;rm -f $sn"
    return 0;
}

main() {
    if [ "$1" = -u ]
    then shift ; cat "$@" | grep ^_ | base64 -di | gzip -d
    elif [ "$1" = -x ]
    then shift ; make_docker_runtxt "$@"
    else make_docker_runcmd "$@"
    fi
}

main "$@"
