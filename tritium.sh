#!/bin/sh

################################################################################
# Script run by docker.

guest_start() {
    set -e
    apk add --no-cache -t build-packages \
	build-base bash gmp-dev git tini
    apk add --no-cache -t run-packages --repositories-file /dev/null \
	gmp tini

    git clone https://github.com/rdebath/Brainfuck.git bfi
    make -C bfi/tritium install DO_LIBDL1= DO_LIBDL2=
    rm -rf bfi
    apk del --repositories-file /dev/null build-packages

    tritium -P'
	+[>[<->+[>+++>++>[++++++++>][]-[<]>-]]++++++++++++++<]>>>>>>>>+.<<<<+++.
	---.>.<+++.>>++.<<-----.<++.>>>+.<<++++++++.>++.+++.>++.<<<.>--.++.>>-..
	++.<<--..>>+.<<++.>.<<<+.<----.
    '
}

################################################################################

main() {
    case "$1" in
    '' ) make_dockerfile "$0" ;;
    build ) make_dockerfile "$0" | docker build ${2:+-t "$2"} - ;;
    start) guest_start ;;

    * ) echo >&2 Bad option ; exit 2;;
    esac
}

make_dockerfile() {
    echo 'FROM alpine:3.8'
    echo 'WORKDIR /root'
    make_docker_runcmd "$1" '' start
    echo 'ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/tritium"]'
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
