#!/usr/bin/env bash
# shellcheck shell=bash
# shellcheck disable=SC1003,SC2001
if [ -z "$BASH_VERSION" ];then exec bash "$0" "$@";else set +o posix;fi

#########################################################
# Dockerfile script command disposition                 #
#                                                       #
# FROM        - Only first                              #
# ENV         - Probably needed                         #
# ARG         - Probably needed                         #
# WORKDIR     - Only first                              #
# LABEL       - Not significant                         #
#                                                       #
# RUN         - Embed if needed                         #
# USER        - Will break installer                    #
# SHELL       - Will break installer                    #
#                                                       #
# ADD         - Run added script (Two layers)           #
# COPY        - Run added script (Two layers)           #
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
	-r|-f ) rmode="$ar" ;;
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
    -r ) for ar in "${arg[@]}" ;do make_docker_runcmd "$ar" ; done ;;
    "" ) for ar in "${arg[@]}" ;do make_dockerrun "$ar" ; done ;;
    * )
	ar=$(bash "$0" "${arg[@]}")
	echo "$ar" | docker build -q "${barg[@]}" -
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

Make a run command
    $0 -r shell_script.sh

Make a dockerfile from scripts, files and directories
    $0 -f main_script otherfile dest_location=file_or_directory.
!

}

################################################################################
# Simple routine to embed a nice scriptfile into a RUN command.

make_docker_runcmd() {
    # Limit per "run" is library exec arg length (approx 128k)
    local script="$1" sname="/tmp/install"
    echo 'RUN set -eu;_() { echo "$@";};(\'
    gzip -cn9 "$script" | base64 -w 72 | sed 's/.*/_ &;\\/'
    echo ")|base64 -d|gzip -d>$sname;sh $sname;rm -f $sname"
}

################################################################################
# The input file is a shell script with docker commands in comments.
# Docker commands use lines starting with "#DOCKER:"

make_dockerrun() {
    # Limit per "run" is library exec arg length (approx 128k)
    local scriptfile scriptargs sc
    scriptfile="$(cat "$1")"
    scriptargs="$(echo "$scriptfile" | sed -n 's/^#DOCKER://p')"

    # Check for file with multiple parts
    sc=$(echo "$scriptargs" | sed -n 's/^\(COMMIT\|BEGIN\|SAVE\)//p' | wc -l)
    [ "$sc" -ne 0 ] && {
	make_dockerrun_ex "$scriptfile" "$2"
	return
    }

    local sname="/tmp/install"
    [ "$2" != '' ] && sname="'${2}'"
    scriptfile=$(echo "$scriptfile"|sed '/^#DOCKER:/d')

    # Keep 1*FROM, 1*WORKDIR, n*ARG, n*ENV, n*LABEL
    echo "$scriptargs" |
    awk '
	/^FROM / && fc!=1 { fc=1; print ; next; }
	/^WORKDIR / && wd!=1 { wd=1; print ; next; }
	/^ARG|^ENV|^LABEL|^#/ { print; next ; }
	/^INCLUDE/ {next;}
	{exit;}'

    echo 'RUN set -eu;_() { echo "$@";};\'
    enc() { echo '(\';cat "$@"|gzip -cn9|base64 -w 72|sed 's/.*/_ &;\\/';}

    echo "$scriptargs" | sed -n 's/^INCLUDE[	 ]\+//p' |
    while IFS= read -r line
    do
	src="${line%% *}" ; dst="${line#* }"
	if [ -d "$src" ];then
	    echo "mkdir -p $dst;\\"
	    tar c --owner=root --group=root --mode=og=u-w,ug-s \
		-f - -C "$src" . | enc
	    echo ")|base64 -d|gzip -d|tar x -C $dst -f -;\\"
	elif [ -e "$src" ];then
	    enc "$src" ; echo ")|base64 -d|gzip -d>$dst;\\"
	else
	    echo >&2 "WARNING: Include file does not exist: '$src'"
	fi
    done

    echo "$scriptfile" | enc
    echo ")|base64 -d|gzip -d>$sname;sh $sname;rm -f $sname"

    sc=$(echo "$scriptargs" |
    awk '
	/^FROM / && fc!=1 { fc=1; next; }
	/^WORKDIR / && wd!=1 { wd=1; next; }
	/^ARG|^ENV|^LABEL|^#/ && t!=1 { next ; }
	/^INCLUDE/ {next;}
	{fc=1;wd=1;t=1;print;}' )

    [ "$sc" != '' ] && echo "$sc"
    return 0
}

################################################################################
# The input file is a shell script with docker commands in comments.
# Docker commands use lines starting with "#DOCKER:"
#
# This variant uses BEGIN and COMMIT commands to split the input script.

make_dockerrun_ex() {
    local scriptfile="$1"
    local sname="${2:-install}"

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

################################################################################
# Uninstall apk from alpine linux.

docker_remove_apk() {
    # Remove apk
    apk del --repositories-file /dev/null apk-tools alpine-keys libc-utils

    # Delete apk installation data
    rm -rf /var/cache/apk /lib/apk /etc/apk
}

################################################################################
#
# TODO: if grep -qa /.\*/ /proc/1/cgroup ; then guest_main ; else main ; fi

main "$@"
