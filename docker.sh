#!/bin/sh -
DOCKER=/usr/bin/docker
SUDO=''
[ -w /var/run/docker.sock ] || {
    [ "$(id -u)" -ne 0 ] &&
	SUDO='sudo -g docker --'
}

main() {
    case "$1" in
    delete ) shift ; docker_delete "$@" ;;
    list ) shift ; docker_list "$@" ;;
    search ) shift ; docker_search "$@" ;;
    ls ) shift ; docker_ls "$@" ;;

    push ) shift ; docker_push "$@" ;;
    pull ) shift ; docker_pull "$@" ;;

    untag ) shift ; docker_untag "$@" ;;

    build )
	PE='--preserve-env=DOCKER_BUILDKIT,BUILDKIT_PROGRESS'
	SUDO="${SUDO:+sudo -g docker $PE --}"
	exec $SUDO "$DOCKER" "$@"
	;;

    kbuild )
	PE='--preserve-env=DOCKER_BUILDKIT,BUILDKIT_PROGRESS'
	SUDO="${SUDO:+sudo -g docker $PE --}"
	shift
	export DOCKER_BUILDKIT=1
	exec $SUDO "$DOCKER" build "$@"
	;;

    * ) exec $SUDO "$DOCKER" "$@"
	;;
    esac
}

docker_delete() {
    HOST="$1"
    [ "$HOST" = '' ] &&
	HOST=$(jq < ~/.docker/config.json .auths\|keys_unsorted | jq -r .[0])
    AUTH=$(jq < ~/.docker/config.json ".auths.\"$HOST\".auth" | base64 -di)
    RES=$(curl -sS --user "$AUTH" \
	-X DELETE \
	"https://$HOST/v2/$2/manifests/$3")
    echo "$RES" | jq . || echo "$RES"
    exit
}

docker_list() {
    case "$1" in
    -H ) HOST="$2" ; shift 2 ;;
    * ) HOST=$(jq < ~/.docker/config.json .auths\|keys_unsorted | jq -r .[0]) ;;
    esac
    AUTH=$(jq < ~/.docker/config.json ".auths.\"$HOST\".auth" | base64 -di)

    if [ "$1" = '' ]
    then
	RES=$(curl -sS --user "$AUTH" \
	    -X GET \
	    "https://$HOST/v2/_catalog")
	echo "$RES" | jq . || echo "$RES"
    elif [ "$2" = '' ]
    then
	RES=$(curl -sS --user "$AUTH" \
	    -X GET \
	    "https://$HOST/v2/$1/tags/list")
	echo "$RES" | jq . || echo "$RES"
    else
	RES=$(curl -sS --user "$AUTH" \
	    -X GET \
	    "https://$HOST/v2/$1/manifests/$2" \
	    -H 'Accept: application/vnd.docker.distribution.manifest.v2+json' )
	echo "$RES" | jq . || echo "$RES"
    fi
    exit
}

docker_search() {
    $SUDO "$DOCKER" search "$@" | sed 's/   */\t/g' | column -t -s'	'
    exit
}

docker_ls(){
    case "$*" in
    *format* ) shift ; exec $SUDO "$DOCKER" images "$@" ;;

    "" )
	$SUDO "$DOCKER" images \
	    --format "table {{.ID}}\t{{.Size}}\t{{.Repository}}:{{.Tag}}\t{{.CreatedSince}}" \
	    -f dangling=false | \
	    sed 's/   */\t/g' | column -t -s'	'
	;;

    * )
	$SUDO "$DOCKER" images \
	    --format "table {{.ID}}\t{{.Size}}\t{{.Repository}}:{{.Tag}}\t{{.CreatedSince}}" \
	    "$@" | \
	    sed 's/   */\t/g' | column -t -s'	'
	;;
    esac
    exit
}

docker_push() {
    if [ "$#" -gt 1 ]
    then
	case "$1" in
	-* ) ;;
	*)
	    HOST="$1"
	    [ "$HOST" = '' ] &&
		HOST=$(jq < ~/.docker/config.json .auths\|keys_unsorted | jq -r .[0])
	    IMAGE="$2"
	    REPO="$HOST"
	    case "$REPO" in
	    */* ) ;;
	    * ) REPO="$REPO/$(basename "$IMAGE")" ;;
	    esac
	    $SUDO "$DOCKER" tag "$IMAGE" "$REPO"
	    $SUDO "$DOCKER" push "$REPO"
	    $SUDO "$DOCKER" image rm --no-prune "$REPO" >/dev/null
	    exit
	    ;;
	esac
    fi
    exec $SUDO "$DOCKER" push "$@"
}

docker_pull() {
    if [ "$#" -gt 1 ]
    then
	case "$1" in
	-* ) ;;
	*)
	    HOST="$1"
	    [ "$HOST" = '' ] &&
		HOST=$(jq < ~/.docker/config.json .auths\|keys_unsorted | jq -r .[0])
	    IMAGE="$2"
	    REPO="$HOST"
	    case "$REPO" in
	    */* ) ;;
	    * ) REPO="$REPO/$(basename "$IMAGE")" ;;
	    esac
	    $SUDO "$DOCKER" pull "$REPO"
	    $SUDO "$DOCKER" tag "$REPO" $IMAGE
	    $SUDO "$DOCKER" rmi "$REPO"
	    exit
	    ;;
	esac
    fi
    exec $SUDO "$DOCKER" pull "$@"
}

docker_untag() {
    IMAGE="$( docker inspect "$1" | jq -r '.[0]'."RepoDigests"'[0]' )"

    { echo 'from scratch' ; echo 'user 0' ; } |
	docker build -q -t "$1" - &&

    [ "$IMAGE" != null ] &&
	docker rmi "$IMAGE"

    docker rmi "$1"
}

main "$@"
