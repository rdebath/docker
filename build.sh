#!/usr/bin/env bash
# shellcheck shell=bash
# shellcheck disable=SC1003,SC2001
if [ -z "$BASH_VERSION" ];then exec bash "$0" "$@";else set +o posix;fi

# TODO: if grep -qa /.\*/ /proc/1/cgroup ; then Guest ; else Host ; fi

main() {
    set -e

    [ "$#" = 1 ] && {
	case "$1" in
	alpine ) do_alpine ; exit ;;
	centos ) do_centos ; exit ;;
	fedora ) do_fedora ; exit ;;
	debian ) do_debian ; exit ;;
	debian:* ) do_one_debian "${1#debian:}" "deb-${1#debian:}-bf" ; exit ;;
	ubuntu ) do_one_debian "$1" "$1-bf" ; exit ;;
	ubuntu:16.04 ) do_one_debian "$1" "ubuntu-1604-bf" ; exit ;;

	-?* ) echo >&2 Unknown option "$1" ; exit 1 ;;

	* ) make_dockerrun "$1" ; exit ;;
	esac
    }

    [[ "$1" = -b && "$#" -ge 3 ]] && {
	BUILDNAME="$2"
	shift 2
	bash "$0" "$@" | docker build -t "$BUILDNAME" -
	exit
    }

    [[ "$#" = 3 && "$1" = -cp ]] && { docker_cpi "$2" "$3" ; exit ; }
    [[ "$#" = 2 && "$1" = -r ]] && { make_docker_runcmd "$2" ; exit ; }

    case "$1" in
    -f ) shift ; make_docker_files "$@" ; exit ;;

    -h ) Usage ; exit 1 ;;
    -?* ) echo >&2 Unknown option "$1" ; exit 1 ;;
    * ) Usage ; exit 1 ;; 
    esac
}

Usage() {
    cat >&2 <<!
Usage: ...

Make dev images ...
    $0 alpine
    $0 centos
    $0 debian
    $0 debian:stretch
    $0 ubuntu

Copy image to flattened image
    $0 -cp fromimage:fat toimage:squished

Make a run command
    $0 -r shell_script.sh

Make a dockerfile from one script.
    $0 Combined_script

Make a dockerfile from scripts, files and directories
    $0 -f main_script otherfile dest_location=file_or_directory.
!

}

################################################################################
# The input file is a shell script with docker commands in comments.
# Docker commands use lines starting with "#DOCKER:"

make_dockerrun() {
    # Limit per "run" is library exec arg length (approx 128k)
    local bscript script scriptfile scriptargs sc
    local NL lines dlines tailstr runopen
    local sname="install"

    script="$1"
    shift
    case "$script" in
    -|/dev/*|/tmp/* ) bscript='' ;;
    * ) bscript=": $(basename "$script" .sh);" ;;
    esac

    scriptfile="$(cat "$script")"
    scriptargs="$(echo "$scriptfile" | sed -n '/^#DOCKER:/p')"
    sc=$(echo "$scriptargs" |
	sed -n 's/^#DOCKER:\(COMMIT\|BEGIN\|SAVE\)//p' |
	wc -l)

    # Simple version without multiple or additional scripts.
    if [ "$sc" -eq 0 ]
    then
	# Only first FILE before. USER is only after.
	# Eveything after second FILE stays after.
	# Order is not changed, position for run must be chosen.
	# This means a "USER" puts evething after it after this.
	# Use "USER root" (or second WORKDIR) to force this.

	echo "$scriptargs" | sed -n 's/^#DOCKER://p' |
	awk '/^FILE/ && fc!=1 { fc=1; print ; next; }
	    /^FILE|^USER/ { exit ; }
	    {print;}'

	echo "RUN $bscript"'set -eu; e() { echo "$@";};\'
	string_base64 "$(echo "$scriptfile"|sed '/^#DOCKER:/d')" "/tmp/$sname"
	echo "sh '/tmp/$sname';rm -f '/tmp/$sname'"

	echo "$scriptargs" | sed -n 's/^#DOCKER://p' |
	awk '/^FILE/ && fc!=1 { fc=1; next; }
	    /^FILE|^USER/ { t=1; }
	    t==1 {print;}'
	return 0
    fi

    # More complex version
    # Everything (non-dockerfile) outside BEGIN..COMMIT is for the host.
    NL='
'
    lines=()
    dlines=()
    tailstr='#DOCKER:COMMIT'
    nfile="/tmp/$sname"
    runopen=0
    while IFS= read -r line
    do  [ "$line" != "#DOCKER:FLUSH" ] || line="$tailstr"
	case "$line" in
	"#DOCKER:BEGIN" )
	    [ "${#dlines[*]}" -gt 0 ] && echo "$(IFS="$NL" ; echo "${dlines[*]}")"
	    dlines=()
	    # Discard host lines.
	    lines=()
	    tailstr='#DOCKER:COMMIT'
	    nfile="/tmp/$sname"
	    ;;
	"#DOCKER:COMMIT" )
	    [ "${#lines[*]}" -gt 0 ] && {
		[ "$runopen" = 0 ] && {
		    echo "RUN $bscript"'set -eu; e() { echo "$@";};\'
		    bscript=''
		}
		string_base64 "$(IFS="$NL" ; echo "${lines[*]}")" "$nfile"
		runopen=1
		lines=()
	    }

	    [ "$runopen" != 0 ] &&
		echo "sh '/tmp/$sname';rm -f '/tmp/$sname'"
	    runopen=0
	    [ "${#dlines[*]}" -gt 0 ] && echo "$(IFS="$NL" ; echo "${dlines[*]}")"
	    dlines=()

	    tailstr=
	    ;;
	"#DOCKER:SAVE"* )
	    [ "${#lines[*]}" -gt 0 ] && {
		[ "$runopen" = 0 ] && {
		    echo "RUN $bscript"'set -eu; e() { echo "$@";};\'
		    bscript=''
		}
		string_base64 "$(IFS="$NL" ; echo "${lines[*]}")" "/tmp/$sname"
		runopen=1
		lines=()
	    }
	    nfile=$(echo "$line" | sed 's/^#DOCKER:SAVE[ 	]*//')
	    ;;
	"#DOCKER:FROM"* )
	    if [[ "$runopen" = 0 && "${#dlines[*]}" -eq 0 ]]
	    then echo "$line" | sed 's/^#DOCKER://'
	    else
		line=$(echo "$line" | sed 's/^#DOCKER://')
		dlines+=("$line")
		[ "$tailstr" = '' ] && tailstr='#DOCKER:BEGIN'
	    fi
	    ;;
	"#DOCKER:"* )
	    line=$(echo "$line" | sed 's/^#DOCKER://')
	    dlines+=("$line")
	    [ "$tailstr" = '' ] && tailstr='#DOCKER:BEGIN'
	    ;;
	* ) lines+=("$line") ;;
	esac
    done < <(echo "$scriptfile" ; echo '#DOCKER:FLUSH' )
}

string_base64() {
    local file="$1" nfile="$2" mode="$3"
    echo '(\'
    echo "$file" | gzip -n9 | base64 -w 72 | sed 's/.*/e &;\\/'
    echo ')|base64 -d|gzip -d >'"'$nfile'"';\'
    [ "$mode" = "" ] || echo "chmod $mode '$nfile'"';\'
}

################################################################################

make_docker_files() {
    # Limit per "run" is library exec arg length (approx 128k)
    local bscript script scriptfile scriptargs f
    local sname="install"

    script="$1"
    shift
    case "$script" in
    -|/dev/*|/tmp/* ) bscript='' ;;
    * ) bscript=": $(basename "$script" .sh);" ;;
    esac

    scriptfile="$(cat "$script")"
    scriptargs="$(echo "$scriptfile" | sed -n '/^#DOCKER:/p')"
    echo "$scriptargs" | sed -n 's/^#DOCKER:FROM\>/FROM/p'
    f="$(echo "$scriptfile" | sed '/^#DOCKER:/d')"

    echo "RUN $bscript"'set -eu; e() { echo "$@";};\'
    echo '(\'
    echo "$f" | gzip -n9 | base64 -w 72 | sed 's/.*/e &;\\/'
    echo ')|base64 -d|gzip -d >'"'/tmp/$sname'"';\'

    for file
    do  nfile=""
	case "$file" in
	*=* ) nfile="${file%%=*}" ; file="${file#*=}" ;;
	run:*|RUN:* )
	    echo "sh '/tmp/$sname';rm -f '/tmp/$sname'"
	    script="${file#*:}"
	    bscript=": $(basename "$script" .sh);"

	    echo "RUN $bscript"'set -eu; e() { echo "$@";};\'
	    echo '(\'
	    gzip -cn9 "$script" | base64 -w 72 | sed 's/.*/e &;\\/'
	    echo ')|base64 -d|gzip -d >'"'/tmp/$sname'"';\'
	    continue
	    ;;
	esac
	fname="$(basename "$file")"
	if [ -d "$file" ]
	then
	    if [ "$nfile" = '' ]
	    then
		echo '(\'
		tar cf - "$file" | gzip -n9 | base64 -w 72 | sed 's/.*/e &;\\/'
		echo ')|base64 -d|gzip -d|tar xf -;\'
	    else
		echo 'mkdir -p '"'$nfile'"';\'
		echo '(\'
		(cd "$file" &&
		    tar c --owner=root --group=root --mode=og=u-w,ug-s \
			-f - -- *)|
		    gzip -n9 | base64 -w 72 | sed 's/.*/e &;\\/'
		echo ')|base64 -d|gzip -d|tar x -C '"'$nfile'"' -f -;\'
	    fi
	else
	    [ "$nfile" = '' ] && nfile="/tmp/$fname"
	    echo '(\'
	    gzip -cn9 "$file" | base64 -w 72 | sed 's/.*/e &;\\/'
	    echo ')|base64 -d|gzip -d >'"'$nfile'"';\'
	    [ -x "$file" ] &&
		echo 'chmod +x '"'$nfile'"';\'
	fi
    done

    echo "sh '/tmp/$sname';rm -f '/tmp/$sname'"
    echo "$scriptargs" | sed '/^#DOCKER:FROM/d;s/^#DOCKER://'
}

################################################################################

do_debian() {
    for i in unstable testing buster stretch jessie wheezy wheezy-i386 squeeze
    do do_one_debian $i "deb-$i-bf"
    done
}

do_one_debian() {
    case $1 in 
    wheezy-i386 )
	do_debian_wheezy i386/debian:wheezy "$2" ;;
    wheezy )
	do_debian_wheezy debian:"$1" "$2" ;;
    squeeze )
	do_debian_squeeze debian:"$1" "$2" ;;

    *:* ) do_debian_working "$1" "$2" ;;
    * ) do_debian_working debian:"$1" "$2" ;;
    esac
}

do_debian_working() {
    {
	echo "FROM $1"
	make_docker_runcmd "bfi/x-deb-get.sh"
	echo 'RUN adduser' "$USER" \
	    --uid "$(id -u)" \
	    --home "'/home/$USER'" \
	    --gecos '""' \
	    --disabled-password

	echo 'WORKDIR /home/'"$USER"
	echo "USER $USER:$USER"
	echo 'CMD ["bash", "-l"]'
    } | docker build -t "$2" -
}

do_debian_wheezy() {
    {
	echo "FROM $1"

	make_docker_runcmd <(cat<<\!
cat <<\@ > /etc/apt/apt.conf.d/99unauthenticated
Acquire::Check-Valid-Until false;
// Acquire::AllowInsecureRepositories true;
// APT::Get::AllowUnauthenticated yes;
@
cat <<\@ > /etc/apt/sources.list
deb http://archive.debian.org/debian wheezy main contrib non-free
deb http://archive.debian.org/debian-security wheezy/updates main contrib non-free
@
!
)

	make_docker_runcmd "bfi/x-deb-get.sh"
	echo 'RUN useradd' "$USER" \
	    --uid "$(id -u)" \
	    --home "'/home/$USER'"

	echo 'WORKDIR /home/'"$USER"
	echo "USER $USER:$USER"
	echo 'CMD ["bash", "-l"]'
    } | docker build -t "$2" -
}

do_debian_squeeze() {
    {
	echo "FROM $1"

	make_docker_runcmd <(cat<<\!
cat <<\@ > /etc/apt/apt.conf.d/99unauthenticated
Acquire::Check-Valid-Until false;
Acquire::AllowInsecureRepositories true;
APT::Get::AllowUnauthenticated yes;
@
cat <<\@ > /etc/apt/sources.list
deb http://archive.debian.org/debian squeeze main contrib non-free
deb http://archive.debian.org/debian squeeze-lts main contrib non-free
deb http://archive.debian.org/debian-security squeeze/updates main contrib non-free
@
!
)

	make_docker_runcmd "bfi/x-deb-get.sh"
	echo 'RUN useradd' "$USER" \
	    --uid "$(id -u)" \
	    --home "'/home/$USER'"

	echo 'WORKDIR /home/'"$USER"
	echo "USER $USER:$USER"
	echo 'CMD ["bash", "-l"]'
    } | docker build -t "$2" -
}

make_docker_runcmd() {
    # Limit per "run" is library exec arg length (approx 128k)
    local script="$1" sname="install"
    # Encode the script
    echo 'RUN set -eu; e() { echo "$@";};\'
    echo '(\'
    gzip -cn9 "$script" | base64 -w 72 | sed 's/.*/e &;\\/'
    echo ')|base64 -d|gzip -d >'"'/tmp/$sname'"';\'
    # Run the script
    echo "sh '/tmp/$sname';rm -f '/tmp/$sname'"
}

################################################################################

do_alpine() {
    {
	cat <<-\!
	FROM alpine:latest
	RUN apk add --no-cache -t build-packages \
		build-base bison flex lua gmp-dev openssl-dev cmake gcc-gnat
	!

	# RUN apk add --no-cache --repositories-file /dev/null \
	#   -X "http://dl-cdn.alpinelinux.org/alpine/edge/testing/" tcc

	# echo "VOLUME /home/$USER"
	# echo "LABEL BuildTime \"$(date)\""

	echo 'RUN adduser -D' "$USER"
	echo 'WORKDIR /home/'"$USER"
	echo "USER $USER:$USER"
	echo 'CMD ["sh", "-l"]'
    } | docker build -t alpine-bf -
}

################################################################################

do_centos() {
    {
	echo 'FROM centos:latest'
	echo 'RUN yum groupinstall -y "Development Tools" \'
	echo '&&  yum install -y which gmp-devel openssl-devel clang cmake \'
	echo '&&  yum clean all'

	echo 'RUN adduser -U ' "$USER" \
	    --uid "$(id -u)" \
	    --home "'/home/$USER'"

	echo 'WORKDIR /home/'"$USER"
	echo "USER $USER:$USER"
	echo 'CMD ["bash", "-l"]'
    } | docker build -t centos-bf -
}

################################################################################

do_fedora() {
    {
	echo 'FROM fedora:latest'
	echo 'RUN yum groupinstall -y "C Development Tools and Libraries" \'
	echo '&&  yum install -y which gmp-devel openssl-devel clang cmake \'
	echo '&&  yum install -y diffutils \'
	echo '&&  yum clean all'

	echo 'RUN adduser -U ' "$USER" \
	    --uid "$(id -u)" \
	    --home "'/home/$USER'"

	echo 'WORKDIR /home/'"$USER"
	echo "USER $USER:$USER"
	echo 'CMD ["bash", "-l"]'
    } | docker build -t fedora-bf -
}

################################################################################

docker_remove_apk() {
    # Remove apk
    apk del --repositories-file /dev/null apk-tools alpine-keys libc-utils

    # Delete apk installation data
    rm -rf /var/cache/apk /lib/apk /etc/apk
}

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
    # docker_cpi "src image" "dest image"
    local ID CLIST CFLG c i JSTR CFLG2 MAINTAINER ENTRY

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
	# echo "Maintainer '$CFLG' is not on docker whitelist, converting to LABEL"
	# CLIST+=(-c "LABEL Maintainer $CFLG")
	MAINTAINER="$CFLG"
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

    [ "$1" = "$2" ] ||
	docker rmi "$2" 2>/dev/null ||:

    ID=$(docker create "$1" true)
    docker export "$ID" | docker import "${CLIST[@]}" - "$2"
    docker rm "$ID" >/dev/null

    [ "$MAINTAINER" = '' ] ||
	echo -e "FROM $2\\nMAINTAINER $MAINTAINER" | docker build -t "$2" -
}

################################################################################

main "$@"
