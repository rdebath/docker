#!/bin/bash
# Trivial script to wrap a static binary as a docker image.
#
tar cz -P -h \
    --transform="s:^$1:app:" \
    -f - "$1" |
docker import -m - \
    -c='USER '"$(id -u)" \
    -c='WORKDIR /home' \
    -c='ENTRYPOINT ["/app"]' \
    - ${2:+"$2"}
