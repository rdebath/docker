#!/usr/bin/env bash
# shellcheck shell=bash
# shellcheck disable=SC1003,SC2001
if [ -z "$BASH_VERSION" ];then exec bash "$0" "$@";else set +o posix;fi

#########################################################
# Use this (with the "#" characters)                    #
# : Dockerfile <<@                                      #
# FROM ...                                              #
# Etc                                                   #
# @                                                     #
#                                                       #
# An "@@" at the start of the line marks where a script #
# will be inserted; if missing this script guesses.     #
#                                                       #
#########################################################
# Dockerfile script command disposition                 #
#                                                       #
# FROM        - Keep first, rest after                  #
# ENV         - Probably needed -- keep                 #
# ARG         - Probably needed -- keep                 #
# RUN         - Build image prereqs                     #
# WORKDIR     - Keep first, rest after                  #
# LABEL       - Not significant, keep                   #
# Non-alpha   - Assumed to be a continuation            #
#                                                       #
#########################################################
# All others are placed after body script.              #
#########################################################
#                                                       #
# USER        -                                         #
# SHELL       -                                         #
# ADD         -                                         #
# COPY        -                                         #
# CMD         - Only used by container                  #
# EXPOSE      - Only used by container                  #
# ENTRYPOINT  - Only used by container                  #
# VOLUME      - Only used by container                  #
# STOPSIGNAL  - Only used by container                  #
# HEALTHCHECK - Only used by container                  #
# ONBUILD     - Only used later                         #
# MAINTAINER  - Deprecated                              #
#########################################################

main() {
    set -e
    local ar amode='f' arg=() barg=() bmode=''
    ENCODED=yes

    for ar
    do  case "$ar" in
	-b ) amode='b'; bmode=yes;;
	-x ) ENCODED=no ;;
	-h ) Usage ; exit 1 ;;
	-?* ) echo >&2 "Unknown option '$1'; use -h for help" ; exit 1 ;;
	* ) if [ "$amode" = f ] ; then arg+=("$ar")
	    else barg+=("-t" "$ar")
		 amode='f'
	    fi
	    ;;
	esac
    done
    [ "${#arg}" -eq 0 ] && arg+=("$0")

    if [ "$bmode" != yes ]
    then
	for ar in "${arg[@]}" ;do make_dockerrun "$ar" ; done
    else
	for ar in "${arg[@]}" ;do make_dockerrun "$ar" ; done |
	docker build "${barg[@]}" -
    fi
    exit
}

Usage() {
    cat >&2 <<!
Usage:
Make a dockerfile from script.
    $0 script

Then forward to docker build.
    $0 -b ImageName script
!

}

################################################################################

make_dockerrun() {
    # Limit per "run" is library exec arg length (approx 128k)
    local scriptfile scriptargs scripttail sc re
    scriptfile="$(cat "$1")"

    # Pick a script name.
    local sname="/tmp/install"
    [ "$2" != '' ] && sname="'${2}'"

    # If the file has a "#DOCKERGUEST" line, the guest script follows it.
    sc=$(echo "$scriptfile"|sed '1,/^#DOCKERGUEST/d')
    [ "$sc" != '' ] && scriptfile="$sc"

    # Extract the Dockerfile section(s) from the script.
    re='^[ 	]*:  *[Dd][Oo][Cc][Kk][Ee][Rr] *[Ff][Ii][Ll][Ee] *<< *\(\\\)\?@'
    scriptargs="$(echo "$scriptfile" |
	sed -n "/$re/,/^@\$/p" |
	sed -e "/$re/d" -e \$d -e 's/[ 	]\+$//')"

    [ "$scriptargs" = '' ] ||
	scriptfile=$(echo "$scriptfile" |
	    sed -e "/$re/,/^@\$/d" -e '1,/./{/^$/d}')

    if [ "$scriptargs" != '' ]
    then
	# Split the dockerfile to choose where to insert the encoded script.
	# Keep 1*FROM, 1*WORKDIR, n*RUN, n*ARG, n*ENV, n*LABEL
	# Or split on the first "@"
	sc=$(echo "$scriptargs" |
	    awk 'BEGIN{rn=0;}
		/^FROM / && fc!=1 { fc=1; next; }
		/^WORKDIR / && wd!=1 { wd=1; next; }
		/^RUN|^ARG|^ENV|^LABEL|^[^A-Z@a-z]|^$/ { next; }
		/^@/{rn=NR;exit;}
		{if(rn==0)rn=NR;}
		END{if(rn==0)rn=NR+1;print rn;}')

	scripttail=$(echo "$scriptargs" | sed -e "1,$((sc-1))d" -e '/^@/d' )

	# Print out the converted file.
	echo "$scriptargs" | sed -e "$((sc)),\$d" -e '/^@/d'
    fi

    if [ "$ENCODED" = yes ]&&[ "$scriptargs" != '' ]
    then
	echo 'RUN set -eu;_() { echo "$@";};(\'
	echo "$scriptfile" | gzip -cn9 | base64 -w 72 | sed 's/.*/_ &;\\/'
	echo ")|base64 -d|gzip -d>$sname;sh -e $sname;rm -f $sname"
    else
	echo "$scriptfile" | make_docker_runtxt -
    fi

    [ "$scripttail" != '' ] && echo "$scripttail"
    return 0
}

make_docker_runtxt() {
    sname="/tmp/install"
    echo "RUN set -e;(\\"
    cat "$@" |
	while IFS= read -r line
	do echo echo "${line@Q};"\\
	done
    echo ")>$sname;sh -e $sname;rm -f $sname"
    return 0;
}

main "$@" ; exit

#DOCKERGUEST
#!/bin/sh
# Put your guest script here
