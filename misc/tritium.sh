#!/bin/sh
# shellcheck disable=SC1004

################################################################################
# Script run by docker.

guest_start() {
    set -e
    apk add --no-cache -t build-packages \
	build-base bash gmp-dev git tini
    apk add --no-cache -t run-packages --repositories-file /dev/null \
	gmp tini

    git clone https://github.com/rdebath/Brainfuck.git bfi
    make -j -C bfi/tritium install MARCH= DEFS=-DDISABLE_RUNC=1
    rm -rf bfi
    apk del --repositories-file /dev/null build-packages

    # Might as well upgrade everything
    apk upgrade

    # Remove apk
    apk del --repositories-file /dev/null apk-tools alpine-keys libc-utils

    # Delete apk installation data
    rm -rf /var/cache/apk /lib/apk /etc/apk
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

    # Because we upgrade all packages and remove apk.
    echo 'FROM scratch'
    echo 'COPY --from=0 / /'
    echo 'WORKDIR /root'

    # Final test
    echo 'RUN tritium >&2 -P" \
	+[>[<->+[>+++>++>[++++++++>][]+[<]>-]]+++ \
	+++++++++++<]>>>>>>>>-.<<<<+.---.>--.<+++ \
	.>>.<<-----.<++.>+++++++.>--.<-.+.<.>-.++ \
	.>--..++.<--..>+.<++.>++++++.<<<+.<----. "'

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
