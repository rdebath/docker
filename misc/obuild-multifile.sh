#!/usr/bin/env bash
# shellcheck shell=bash
# shellcheck disable=SC1003,SC2001
if [ -z "$BASH_VERSION" ];then exec bash "$0" "$@";else set +o posix;fi

#########################################################
# Dockerfile script command disposition                 #
#                                                       #
# FROM        - Keep first, rest after                  #
# ENV         - Probably needed                         #
# ARG         - Probably needed                         #
# WORKDIR     - Keep first, rest after                  #
# LABEL       - Not significant                         #
#                                                       #
# RUN         - Place after script                      #
# USER        - Will break install script (place after) #
# SHELL       - Will break install script (place after) #
#                                                       #
# ADD         - Place after script (Two layers)         #
# COPY        - Place after script (Two layers)         #
#                                                       #
# CMD         - Only used by container                  #
# EXPOSE      - Only used by container                  #
# ENTRYPOINT  - Only used by container                  #
# VOLUME      - Only used by container                  #
# MAINTAINER  - Deprecated                              #
# ONBUILD     - Only used later                         #
# STOPSIGNAL  - Only used by container                  #
# HEALTHCHECK - Only used by container                  #
#########################################################

main() {
    set -e
    local rmode='' ar amode='f' arg=() barg=() bmode=''

    for ar
    do  case "$ar" in
	-b ) amode='b'; bmode=yes;;
	-f ) rmode="$ar" ;;
	-h ) Usage ; exit 1 ;;
	-?* ) echo >&2 "Unknown option '$1'; use -h for help" ; exit 1 ;;
	* ) if [ "$amode" = f ] ; then arg+=("$ar")
	    else barg+=("-t" "$ar")
		 amode='f'
	    fi
	    ;;
	esac
    done
    [ "${#arg}" -eq 0 ] && arg+=(-)

    case "$bmode$rmode" in
    -f ) make_docker_files "${arg[@]}" ;;
    "" ) for ar in "${arg[@]}" ;do make_dockerrun "$ar" ; done ;;
    * )
	ar=$(bash "$0" "${arg[@]}")
	echo "$ar" | docker build "${barg[@]}" -
	;;
    esac
    exit
}

Usage() {
    cat >&2 <<!
Usage: ...

Make a dockerfile from script with #DOCKER: lines
    $0 script

Forward to docker build
    $0 -b ImageName ...

Make a dockerfile from scripts, files and directories
    $0 -f main_script otherfile dest_location=file_or_directory.
!

}

################################################################################
# The input file is a shell script with docker commands in comments.
# Docker commands use lines starting with "#DOCKER:"
#
# This variant uses BEGIN and COMMIT commands to split the input script.

make_dockerrun() {
    # Limit per "run" is library exec arg length (approx 128k)
    local scriptfile scriptargs
    local sname="${2:-install}"

    scriptfile="$(cat "$1")"
    scriptargs="$(echo "$scriptfile" | sed -n 's/^#DOCKER://p')"

    echo '#!/usr/bin/env docker-buildfile'
    # More complex version
    local NL lines dlines tailstr runopen

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
		    echo 'RUN set -eu;_() { echo "$@";};\'
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
		    echo 'RUN set -eu;_() { echo "$@";};\'
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
    echo "$file" | gzip -n9 | base64 -w 72 | sed 's/.*/_ &;\\/'
    echo ')|base64 -d|gzip -d >'"'$nfile'"';\'
    [ "$mode" = "" ] || echo "chmod $mode '$nfile'"';\'
}

################################################################################
# Take a list of commands and convert them to RUN commands.
# Other docker commands are extracted from the first.

make_docker_files() {
    # Limit per "run" is library exec arg length (approx 128k)
    local script scriptfile scriptargs f
    local sname="install"

    script="$1"
    shift

    scriptfile="$(cat "$script")"
    scriptargs="$(echo "$scriptfile" | sed -n '/^#DOCKER:/p')"
    echo "$scriptargs" | sed -n 's/^#DOCKER:FROM\>/FROM/p'
    f="$(echo "$scriptfile" | sed '/^#DOCKER:/d')"

    echo 'RUN set -eu;_() { echo "$@";};\'
    echo '(\'
    echo "$f" | gzip -n9 | base64 -w 72 | sed 's/.*/_ &;\\/'
    echo ')|base64 -d|gzip -d >'"'/tmp/$sname'"';\'

    for file
    do  nfile=""
	case "$file" in
	*=* ) nfile="${file%%=*}" ; file="${file#*=}" ;;
	run:*|RUN:* )
	    echo "sh '/tmp/$sname';rm -f '/tmp/$sname'"
	    script="${file#*:}"

	    echo 'RUN set -eu;_() { echo "$@";};\'
	    echo '(\'
	    gzip -cn9 "$script" | base64 -w 72 | sed 's/.*/_ &;\\/'
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
		tar cf - "$file" | gzip -n9 | base64 -w 72 | sed 's/.*/_ &;\\/'
		echo ')|base64 -d|gzip -d|tar xf -;\'
	    else
		echo 'mkdir -p '"'$nfile'"';\'
		echo '(\'
		(cd "$file" &&
		    tar c --owner=root --group=root --mode=og=u-w,ug-s \
			-f - -- *)|
		    gzip -n9 | base64 -w 72 | sed 's/.*/_ &;\\/'
		echo ')|base64 -d|gzip -d|tar x -C '"'$nfile'"' -f -;\'
	    fi
	else
	    [ "$nfile" = '' ] && nfile="/tmp/$fname"
	    echo '(\'
	    gzip -cn9 "$file" | base64 -w 72 | sed 's/.*/_ &;\\/'
	    echo ')|base64 -d|gzip -d >'"'$nfile'"';\'
	    [ -x "$file" ] &&
		echo 'chmod +x '"'$nfile'"';\'
	fi
    done

    echo "sh '/tmp/$sname';rm -f '/tmp/$sname'"
    echo "$scriptargs" | sed '/^#DOCKER:FROM/d;s/^#DOCKER://'
}

# TODO: if grep -qa /.\*/ /proc/1/cgroup ; then guest_main ; else main ; fi

main "$@"
