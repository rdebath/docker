#!/bin/bash

# This script copies a docker image flattening the layers into one and
# removing the layer history.
#
# // whitelist of commands allowed for a commit/import
# var validCommitCommands = map[string]bool{
# 	"entrypoint": true,
# 	"cmd":        true,
# 	"user":       true,
# 	"workdir":    true,
# 	"env":        true,
# 	"volume":     true,
# 	"expose":     true,
# 	"onbuild":    true,
# 	"label":      true,
# }

docker_cpi() {
    # docker_cpi "src image" "dest image"
    local ID CLIST CFLG c i JSTR CFLG2

    CLIST=()

    CFLG=$(docker inspect "$1" --format '{{.Comment}}')
    if [ "$CFLG" != '' ]
    then CLIST+=(-m "$CFLG")
    else CLIST+=(-m -)
    fi

    CFLG=$(docker inspect "$1" --format '{{.Config.User}}')
    [ "$CFLG" != '' ] && CLIST+=(-c "USER $CFLG")

    CFLG=$(docker inspect "$1" --format '{{.Config.WorkingDir}}')
    [ "$CFLG" != '' ] && CLIST+=(-c "WORKDIR $CFLG")

    CFLG=$(docker inspect "$1" --format '{{.Author}}')
    [ "$CFLG" != '' ] && echo "Maintainer '$CFLG' cannot be set"
#   [ "$CFLG" != '' ] && CLIST+=(-c "MAINTAINER $CFLG")

    c=$(docker inspect "$1" --format '{{ len .Config.Env}}')
    for i in $(seq 0 $((c-1)) )
    do
	CFLG="$(docker inspect "$1" --format "{{printf \"%q\" (index .Config.Env $i)}}")"
	CFLG="$(echo "$CFLG" | sed 's/^"\([^=]*\)=/\1 "/')"
	CLIST+=(-c "ENV $CFLG")
    done

    JSTR=''
    c=$(docker inspect "$1" --format '{{ len .Config.Entrypoint}}')
    for i in $(seq 0 $((c-1)) )
    do
	CFLG="$(docker inspect "$1" --format "{{printf \"%q\" (index .Config.Entrypoint $i)}}")"
	[ "$JSTR" != '' ] && JSTR="$JSTR, "
	JSTR="$JSTR$CFLG"
    done
    [ "$JSTR" != '' ] && CLIST+=(-c "ENTRYPOINT [$JSTR]")

    JSTR=''
    c=$(docker inspect "$1" --format '{{ len .Config.Cmd}}')
    for i in $(seq 0 $((c-1)) )
    do
	CFLG="$(docker inspect "$1" --format "{{printf \"%q\" (index .Config.Cmd $i)}}")"
	[ "$JSTR" != '' ] && JSTR="$JSTR, "
	JSTR="$JSTR$CFLG"
    done
    [ "$JSTR" != '' ] && CLIST+=(-c "CMD [$JSTR]")

    c=$(docker inspect "$1" --format '{{ len .Config.OnBuild}}')
    for i in $(seq 0 $((c-1)) )
    do
	CFLG="$(docker inspect "$1" --format "{{printf \"%s\" (index .Config.OnBuild $i)}}")"
	CLIST+=(-c "ONBUILD $CFLG")
    done

    [ "$(docker inspect "$1" --format '{{len .Config.ExposedPorts }}')" -gt 0 ] && {
	# These can be actioned with --publish-all on run.
	# The host port numbers used are random, so this is very limited.
	# "docker port" can be used to find them.

	JSTR="$(docker inspect "$1" | jq .[0].Config.ExposedPorts\|keys)"
	c="$(echo "$JSTR" | jq length)"
	for i in $(seq 0 $((c-1)) )
	do  CFLG="$(echo "$JSTR" | jq .[$i])"
	    CLIST+=(-c "EXPOSE $CFLG")
	done
    }
    [ "$(docker inspect "$1" --format '{{len .Config.Volumes }}')" -gt 0 ] && {
	# Only creates unnamed volumes
	# These are never automatically reused and so are not persistent.
	# docker inspect "$1" --format '{{printf "%#v" .Config.Volumes }}'

	JSTR="$(docker inspect "$1" | jq .[0].Config.Volumes\|keys)"
	c="$(echo "$JSTR" | jq length)"
	for i in $(seq 0 $((c-1)) )
	do  CFLG="$(echo "$JSTR" | jq .[$i])"
	    CLIST+=(-c "VOLUME $CFLG")
	done
    }
    [ "$(docker inspect "$1" --format '{{len .Config.Labels }}')" -gt 0 ] && {
	# These have no use as they are difficult to view.
	# docker inspect "$1" --format '{{printf "%#v" .Config.Labels }}'
	# docker inspect alpine-build | jq .[0].Config.Labels

	JSTR="$(docker inspect "$1" | jq .[0].Config.Labels\|keys)"
	c="$(echo "$JSTR" | jq length)"
	for i in $(seq 0 $((c-1)) )
	do  CFLG="$(echo "$JSTR" | jq .[$i])"
	    CFLG2="$(docker inspect "$1" | jq .[0].Config.Labels."$CFLG")"
	    CLIST+=(-c "LABEL $CFLG $CFLG2")
	done
    }

    # awk 'BEGIN{for(i=1; i<ARGC; i++) {printf "\047%s\047\n", ARGV[i]; delete ARGV[i]; }; }' "${CLIST[@]}"

    docker rmi "$2" 2>/dev/null ||:

    ID=$(docker create "$1" true)
    docker export "$ID" | docker import "${CLIST[@]}" - "$2"
    docker rm "$ID" >/dev/null
}

docker_cpi "$@"
