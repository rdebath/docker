#!/bin/sh
TASK="${1:-help}" ;[ $# -gt 0 ]&&shift

install() {
    chmod +x "$0"
    cp -p "$0" /usr/local/bin/startup
    sed -i 's/^TASK=\(.*\)/TASK=main # \1/' /usr/local/bin/startup

    mkdir -p /opt/samba
}

main() {
    # TODO: Samba VM joined to domain
    exec sh
}

help() {
    cat <<@
sh "$0" build      # Create a Dockerfile
sh "$0" help       # This message
sh -e "$0" install # Script run by Docker during build
sh "$0" main       # Script run by VM at runtime.
@
    exit 1
}

build() {
    F="$0"; N=/tmp/mk; R=install ; D="rm -f $N"
    cat<<@
FROM alpine
RUN apk --no-cache add bash samba shadow tini tzdata

@
    echo 'RUN set -eu;_() { echo "$@";};'"(\\"
    gzip -cn9 "$F" | base64 -w 72 | sed 's/.*/_ &;\\/'
    echo ")|base64 -d|gzip -d>$N;sh -e $N${R:+ $R}${D:+;$D}"
    cat <<\@

WORKDIR /mnt
CMD [ "startup" ]
@
}

eval "task() { '$TASK' \"\$@\"; exit;}"; task "$@"
