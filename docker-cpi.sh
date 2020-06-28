#!/usr/bin/env bash
# shellcheck shell=bash
# shellcheck disable=SC1003,SC2001
if [ -z "$BASH_VERSION" ];then exec bash "$0" "$@";else set +o posix;fi

################################################################################
# This function copies a docker image flattening the layers into one and
# removing the layer history.
#
# // whitelist of commands allowed for a commit/import
# var validCommitCommands = map[string]bool{
#       "entrypoint": true,
#       "cmd":        true,
#       "user":       true,
#       "workdir":    true,
#       "env":        true,
#       "volume":     true,
#       "expose":     true,
#       "onbuild":    true,
#       "label":      true,
# }

docker_cpi() {
    # docker_cpi "src image" "dest image" "ssh host"
    local ID CLIST CFLG c i JSTR CFLG2 MAINTAINER ENTRY

    printf ' Opening and inspecting ...\r'
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
    [ "$CFLG" != '' ] && {
	if [ "$3" != '' ]
	then
	    echo "Maintainer '$CFLG' is not on docker whitelist, converting to LABEL"
	    CLIST+=(-c "LABEL Maintainer $CFLG")
	else
	    MAINTAINER="$CFLG"
	fi
    }

    c=$(docker inspect "$1" --format '{{ len .Config.Env}}')
    for i in $(seq 0 $((c-1)) )
    do
	CFLG="$(docker inspect "$1" --format "{{printf \"%q\" (index .Config.Env $i)}}")"
	CFLG="$(echo "$CFLG" | sed 's/^"\([^=]*\)=/\1 "/')"
	CLIST+=(-c "ENV $CFLG")
    done

    ENTRY=''
    c=$(docker inspect "$1" --format '{{ len .Config.Entrypoint}}')
    for i in $(seq 0 $((c-1)) )
    do
	CFLG="$(docker inspect "$1" --format "{{printf \"%q\" (index .Config.Entrypoint $i)}}")"
	[ "$ENTRY" != '' ] && ENTRY="$ENTRY, "
	ENTRY="$ENTRY$CFLG"
    done
    [ "$ENTRY" != '' ] && CLIST+=(-c "ENTRYPOINT [$ENTRY]")

    JSTR=''
    c=$(docker inspect "$1" --format '{{ len .Config.Cmd}}')
    for i in $(seq 0 $((c-1)) )
    do
	CFLG="$(docker inspect "$1" --format "{{printf \"%q\" (index .Config.Cmd $i)}}")"
	[ "$JSTR" != '' ] && JSTR="$JSTR, "
	JSTR="$JSTR$CFLG"
    done
    if [ "$JSTR" != '' ]
    then CLIST+=(-c "CMD [$JSTR]")
    elif [ "$ENTRY" = '' ]
    then # No start command ... humm, okay, lets add one.
	 CLIST+=(-c "CMD [\"sh\"]")
    fi

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
	# docker inspect "$1" --format '{{json .Config.Labels}}'
	# docker inspect "$1 | jq .[0].Config.Labels

	JSTR="$(docker inspect "$1" | jq .[0].Config.Labels\|keys)"
	c="$(echo "$JSTR" | jq length)"
	for i in $(seq 0 $((c-1)) )
	do  CFLG="$(echo "$JSTR" | jq .[$i])"
	    CFLG2="$(docker inspect "$1" | jq .[0].Config.Labels."$CFLG")"
	    CLIST+=(-c "LABEL $CFLG $CFLG2")
	done
    }
    SIZE=$(docker inspect --format "{{.Size}}" "$1")

    printf '                           \r'

    # printf '%s\n' "${CLIST[@]@Q}" ; exit

    [[ "$1" != "$2" && "$3" = '' ]] && {
	docker rmi "$2" 2>/dev/null ||:
    }

    ID=$(docker create "$1" true)
    if [ "$3" = '' ]
    then docker export "$ID" | pv -s "$SIZE" | docker import "${CLIST[@]}" - "$2"
    else docker export "$ID" |
	    pv -s "$SIZE" |
	    gzip |
	    ssh "$3" docker import "${CLIST[@]@Q}" - "${2@Q}"
    fi
    docker rm "$ID" >/dev/null ||:

    [ "$MAINTAINER" = '' ] ||
	echo -e "FROM $2\\nMAINTAINER $MAINTAINER" | docker build -t "$2" -
}

################################################################################

docker_cpi "$@"
