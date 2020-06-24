#!/usr/bin/env bash
# shellcheck shell=bash
# shellcheck disable=SC1003,SC2001
if [ -z "$BASH_VERSION" ];then exec bash "$0" "$@";else set +o posix;fi

# TODO: if grep -qa /.\*/ /proc/1/cgroup ; then Guest ; else Host ; fi

main() {
    set -e

    [ "$#" = 1 ] && {
	case "$1" in
	-?* ) ;;
	* ) make_dockerrun "$1" ; exit ;;
	esac
    }

    [[ "$1" = -b && "$#" -ge 3 ]] && {
	BUILDNAME="$2"
	shift 2
	bash "$0" "$@" | docker build -t "$BUILDNAME" -
	exit
    }

    [[ "$#" = 2 && "$1" = -r ]] && { make_docker_runcmd "$2" ; exit ; }
    [[ "$#" -gt 1 && "$1" = -f ]] && { shift ; make_docker_files "$@" ; exit ; }

    case "$1" in
    -h ) Usage ; exit 1 ;;
    -?* ) echo >&2 Unknown option "$1" ; exit 1 ;;
    * ) Usage ; exit 1 ;; 
    esac
}

Usage() {
    cat >&2 <<!
Usage: ...

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
    local scriptfile scriptargs sc
    local sname="${2:-install}"

    scriptfile="$(cat "$1")"
    scriptargs="$(echo "$scriptfile" | sed -n 's/^#DOCKER://p')"

    # Simple version without multiple parts
    sc=$(echo "$scriptargs" | sed -n 's/^\(COMMIT\|BEGIN\|SAVE\)//p' | wc -l)
    if [ "$sc" -eq 0 ]
    then
	# Keep 1*FROM, 1*WORKDIR, n*ARG, n*ENV, n*LABEL

	# FROM		Only first
	# ENV		Probably needed
	# ARG		Probably needed
	# WORKDIR	Only first
	# LABEL		Not significant

	# RUN		Embed if needed
	# USER		Will break installer
	# SHELL		Will break installer

	# ADD		Run added script (Two layers)
	# COPY		Run added script (Two layers)

	# CMD		Only used by container
	# EXPOSE	Only used by container
	# ENTRYPOINT	Only used by container
	# VOLUME	Only used by container
	# MAINTAINER	Deprecated
	# ONBUILD	Only used later
	# STOPSIGNAL	Only used by container
	# HEALTHCHECK	Only used by container

	echo "$scriptargs" |
	awk '
	    /^FROM / && fc!=1 { fc=1; print ; next; }
	    /^WORKDIR / && wd!=1 { wd=1; print ; next; }
	    /^ARG|^ENV|^LABEL|^#/ { print; next ; }
	    {exit;}'

	echo 'RUN set -eu; e() { echo "$@";};\'
	string_base64 "$(echo "$scriptfile"|sed '/^#DOCKER:/d')" "/tmp/$sname"
	echo "sh '/tmp/$sname';rm -f '/tmp/$sname'"

	echo "$scriptargs" |
	awk '
	    /^FROM / && fc!=1 { fc=1; next; }
	    /^WORKDIR / && wd!=1 { wd=1; next; }
	    /^ARG|^ENV|^LABEL|^#/ && t!=1 { next ; }
	    {fc=1;wd=1;t=1;print;}'

	return 0
    fi

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
		    echo 'RUN set -eu; e() { echo "$@";};\'
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
		    echo 'RUN set -eu; e() { echo "$@";};\'
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
    local script scriptfile scriptargs f
    local sname="install"

    script="$1"
    shift

    scriptfile="$(cat "$script")"
    scriptargs="$(echo "$scriptfile" | sed -n '/^#DOCKER:/p')"
    echo "$scriptargs" | sed -n 's/^#DOCKER:FROM\>/FROM/p'
    f="$(echo "$scriptfile" | sed '/^#DOCKER:/d')"

    echo 'RUN set -eu; e() { echo "$@";};\'
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

	    echo 'RUN set -eu; e() { echo "$@";};\'
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

docker_remove_apk() {
    # Remove apk
    apk del --repositories-file /dev/null apk-tools alpine-keys libc-utils

    # Delete apk installation data
    rm -rf /var/cache/apk /lib/apk /etc/apk
}

################################################################################

main "$@"
