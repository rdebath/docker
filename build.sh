#!/usr/bin/env bash
# shellcheck shell=bash
# shellcheck disable=SC1003,SC2001
if [ -z "$BASH_VERSION" ];then exec bash "$0" "$@";else set +o posix;fi

#########################################################
# Dockerfile script command disposition                 #
#                                                       #
# FROM        - Keep first, rest after                  #
# ENV         - Probably needed -- keep                 #
# ARG         - Probably needed -- keep                 #
# WORKDIR     - Keep first, rest after                  #
# LABEL       - Not significant                         #
#                                                       #
# RUN         - Place after script                      #
# USER        - Will break install script (place after) #
# SHELL       - Will break install script (place after) #
#                                                       #
# ADD         - Place after script (more layers)        #
# COPY        - Place after script (more layers)        #
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
    local ar amode='f' arg=() barg=() bmode=''

    for ar
    do  case "$ar" in
	-b ) amode='b'; bmode=yes;;
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

    if [ "$bmode" != yes ]
    then
	for ar in "${arg[@]}" ;do make_dockerrun "$ar" ; done
    else
	ar=$(bash "$0" "${arg[@]}")
	echo "$ar" | docker build "${barg[@]}" -
    fi
    exit
}

Usage() {
    cat >&2 <<!
Usage: ...

Make a dockerfile from script with #DOCKER: lines
    $0 script

Forward to docker build
    $0 -b ImageName ...
!

}

################################################################################
# The input file is a shell script with docker commands in comments.
# Docker commands use lines starting with "#DOCKER:"

make_dockerrun() {
    # Limit per "run" is library exec arg length (approx 128k)
    local scriptfile scriptargs sc
    scriptfile="$(cat "$1")"
    scriptargs="$(echo "$scriptfile" | sed -n 's/^#DOCKER://p')"
    scriptfile=$(echo "$scriptfile"|sed '/^#DOCKER:/d')

    local sname="/tmp/install"
    [ "$2" != '' ] && sname="'${2}'"

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

main "$@"
