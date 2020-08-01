#!/usr/bin/env bash
if [ -z "$BASH_VERSION" ];then exec bash "$0" "$@";else set -e +o posix;fi

host_main() {
    docker_init

    DISABLE_ENCODE=
    while [ "${1#-}" != "$1" ]
    do
	case "$1" in
	# Runnable, output a shell script runnable in the guest
	-r ) RUNNOW=yes ; shift ;;
	# Disable base64 encoding
	-X ) DISABLE_ENCODE=yes ; shift ;;

	- ) break;;
	* ) echo >&2 "Unknown Option $1" ; exit 1;;
	esac
    done

    [ "$#" -eq 0 ] && set -- -
    for i
    do guest_script "$i"
    done
    wait
}

################################################################################
# shellcheck disable=SC2119
guest_script() {
    docker_cmd FROM alpine

    docker_start || {
	apk add --no-cache openvpn
	rm -rf \
	    /etc/*- \
	    /etc/openvpn/down.sh \
	    /etc/openvpn/up.sh
    } ; docker_commit "Install OS"

    if [[ "$1" = '' || "$1" = - ]]
    then
	:
    elif [ -d "$1" ]
    then
	docker_joinnext
	docker_tar /etc/openvpn "$1"
    else
	docker_joinnext
	docker_savefile < "$1" "" /etc/openvpn/openvpn.conf
    fi

    startup_script

    if [[ "$1" = '' || "$1" = - ]]
    then
	docker_cmd VOLUME '["/etc/openvpn"]'
    fi
    docker_cmd "CMD [\"startup\"]"
}

# shellcheck disable=SC1090,SC2120
startup_script() {

    docker_start || {
#!/bin/sh -

[ "$$" != 1 ] && {
    OPENVPN="${1:-/etc/openvpn}"
    cd "${OPENVPN}"
    exec openvpn --config "${OPENVPN}/openvpn.conf"
}

# Not added automatically by alpine.
[ ! -c /dev/net/tun ] && {
    mkdir -p /dev/net
    mknod /dev/net/tun c 10 200
}

# Permissions ?
iptables -L -n >/dev/null || {
    echo >&2 'Note: This needs "iptables-legacy" and --cap-add=NET_ADMIN'
    exit 1
}

# Routing will not be configured.
iptables -w -t nat -C POSTROUTING -o eth+ -j MASQUERADE 2>/dev/null ||
      iptables -t nat -A POSTROUTING -o eth+ -j MASQUERADE

iptables -w -t nat -C POSTROUTING -o tun+ -j MASQUERADE 2>/dev/null ||
      iptables -t nat -A POSTROUTING -o tun+ -j MASQUERADE

################################################################################

OPENVPN=/etc/openvpn
OPENVPNCONF="${OPENVPN}/openvpn.conf"

[ -f "${OPENVPN}/configure.sh" ] &&
    . "${OPENVPN}/configure.sh"

for i in "${OPENVPNCONF}" "${OPENVPN}"/*/openvpn.conf
do  [ -e "$i" ] || continue
    j=$(dirname "$i")
    echo "::respawn:/usr/local/bin/startup '$j'"
    [ -f "$j"/startup.sh ] && sh "$j"/startup.sh
done > /etc/inittab

[ -s /etc/inittab ] && {
    echo '::ctrlaltdel:/sbin/halt' >> /etc/inittab
    exec init
}

echo >&2 OpenVPN configuration not found.
exit 1

    } ; docker_save "Startup script" /usr/local/bin/startup 755
}

################################################################################
# Dockerfile building scriptlets
#
docker_init() {
    RUNNOW= ; DISABLE_ENCODE=
    JOINNEXT=0 ; INRUN=0
    shopt -s lastpipe
}
docker_start() { START_LINE=$((BASH_LINENO[0]+1)) ; }
docker_commit() {
    END_LINE=$((BASH_LINENO[0]-1))
    TEXT=$(sed -n < "${BASH_SOURCE[1]}" "${START_LINE},${END_LINE}p")

    echo "$TEXT" | make_docker_runcmd "$1"
    return 0
}

docker_joinnext() {
    JOINNEXT=1
}

docker_startrun() {
    if [ "$INRUN" = 0 ]
    then echo "RUN ${1:+: $1 ;}"'set -e;_() { echo "$@";};'"$2(\\"
    else echo "${1:+: $1 ;}$2(\\"
    fi
    INRUN=1
}

docker_runtail() {
    if [ "$JOINNEXT" = 1 ]
    then
	echo "$*;\\"
	JOINNEXT=0
	INRUN=1
    else
	echo "$*"
	INRUN=0
    fi
}

docker_cmd() {
    [ "$1" = FROM ] &&
	echo '#--------------------------------------------------------------------------#'
    [ "$RUNNOW" != yes ] && { echo "$@" ; return 0; }

    case "$1" in
    ENV )
	shift;
	case "$1" in
	*=* ) echo export "$@" ;;
	* ) V="$1" ; shift ; echo export "$V=\"$*\"" ;;
	esac
	;;
    ARG ) echo "export \"$1\"" ;;
    WORKDIR ) echo "mkdir -p \"$2\"" ; echo "cd \"$2\"" ;;

    '') ;;
    * ) echo "# $*" ;;
    esac
}

make_docker_runcmd() {
    local sn="/tmp/install"
    local line

    [ "$RUNNOW" = yes ] && {
	echo '('
	cat -
	echo ')'
	return 0
    }
    [ "$DISABLE_ENCODE" = yes ] && {
	# Note the sed command might break your script; maybe.
	# It reduces the size of the Dockerfile and if in DISABLE_ENCODE mode
	# significantly reduces the occurance of $'...' strings.
	docker_startrun "$1"
	sed -e 's/^[\t ]\+//' -e 's/^#.*//' -e '/^$/d' |
	    while IFS= read -r line
	    do echo echo "${line@Q};"\\
	    done
	echo ")>$sn;sh -e $sn;rm -f $sn"
	return 0;
    }
    # Limit per "run" is library exec arg length (approx 128k)
    # Encode the script
    docker_startrun "$1"
    gzip -cn9 | base64 -w 72 | sed 's/.*/_ &;\\/'
    docker_runtail ')|base64 -d|gzip -d>'"$sn;sh -e $sn;rm -f $sn"
}

docker_save() {
    END_LINE=$((BASH_LINENO[0]-1))
    TEXT=$(sed -n < "${BASH_SOURCE[1]}" "${START_LINE},${END_LINE}p")

    echo "$TEXT" | docker_savefile "$1" "$2" "$3"
    return 0
}

docker_savefile() {
    # Encode the script
    local sn="${2:-/tmp/install}"
    local md
    md=$(dirname "$sn")
    case "$md" in
    .|/root|/tmp )
	docker_startrun "$1"
	;;
    * ) docker_startrun "$1" "mkdir -p $md;" ;;
    esac
    gzip -cn9 | base64 -w 72 | sed 's/.*/_ &;\\/'
    if [ "$3" = '' ]
    then
	docker_runtail ")|base64 -d|gzip -d>$sn"
    else
	echo ")|base64 -d|gzip -d>$sn;\\"
	docker_runtail "chmod $3 $2"
    fi
}

docker_tar() {
    local TARGET="$1"
    local HOSTDIR="$2"
    tar c \
	--owner=root --group=root \
	--mode=og-w,ug-s \
	--sort=name \
	--mtime="$(date +%Y)-01-01 12:00:00" \
	-f - -C "$HOSTDIR" . |
    {
	docker_startrun '' "mkdir -p '$TARGET';"
	gzip -n9 | base64 -w 72 | sed 's/.*/_ &;\\/'
	docker_runtail ")|base64 -d|gzip -d|tar xf - -C '$TARGET'"
    }
}

################################################################################

host_main "$@"
