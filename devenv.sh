#!/usr/bin/env bash
# shellcheck disable=SC1003,SC2001
#
# vim: set et ts=8 sw=4 sts=4:
# ^ DISABLE_ENCODE mode uses $'...' for tabs; some shells don't.
#
# This script generates a shell or dockerfile script to install a development
# environment. Currently for most OS variants it installs a bare copy of the
# essential build tools; whatever that means for the distribution. For Debian
# based and derived versions it installs more.
#
if [ -z "$BASH_VERSION" ];then exec bash "$0" "$@";else set +o posix;fi
set -e

host_main() {
    docker_init
    ENC_OFF=
    REPOPREFIX=
    DOPUSH=
    while [ "${1#-}" != "$1" ]
    do
        case "$1" in
        # Runnable, output a shell script runnable in the guest
        -r ) RUNNOW=yes ; shift ;;
        # Build, feed the dockerfile into docker build
        -b ) BUILD=yes ; shift ;;
        # Disable encoding
        -X ) ENC_OFF=yes ; shift ;;

        -R ) REPOPREFIX="${2:+$2/}" ; shift 2;;
        -P ) DOPUSH=yes; shift;;

        * ) echo >&2 "Unknown Option $1" ; exit 1;;
        esac
    done

    grep -q vsyscall /proc/cmdline ||
        echo >&2 WARNING: Old distros need vsyscall=emulate on the host.

    # $1 is the FROM image.
    if [ "$1" != '' ]||[ "$RUNNOW" = yes ]
    then build_one "$1" ; wait
    else

        for base in \
            debian ubuntu alpine centos fedora opensuse/leap archlinux \
            localhost/debian:unstable-i386 localhost/debian:unstable \
            localhost/debian:bullseye localhost/debian:bullseye-i386 \
            localhost/debian:buster-i386 localhost/debian:jessie-i386 \
            localhost/debian:jessie localhost/debian:buster \
            localhost/debian:wheezy-i386 localhost/debian:squeeze-i386 \
            localhost/debian:wheezy localhost/debian:stretch-i386 \
            localhost/debian:stretch localhost/debian:squeeze \
            localhost/debian:lenny-i386 localhost/debian:lenny
        do build_one $base
        done

        ENC_OFF=yes
        for base in \
            localhost/debian:etch-i386 localhost/debian:etch \
            localhost/debian:sarge localhost/debian:woody \
            localhost/debian:potato
        do build_one $base
        done

        wait
    fi
}

build_one() {
    case "$1" in
    "" )
        DISABLE_ENCODE="$ENC_OFF"
        [ "$RUNNOW" = yes ] && echo '#!/bin/sh -'
        guest_script
        return 0
        ;;

    *suse*|amazonlinux ) DISABLE_ENCODE=yes ;;
    * ) DISABLE_ENCODE="$ENC_OFF" ;;
    esac

    local I
    I="$(echo :"$1"- | tr ':/' '--' | tr -d . | \
        sed -e 's/-latest-/-/' \
            -e 's/-debian-/-/' \
            -e 's/-rdb-/-/' \
            -e 's/-localhost-/-/' \
            -e 's/^-//' -e 's/-$//' )"

    [ "$I" = '' ] && I="$1"
    I="${REPOPREFIX}devel:$I"

    if [ "$BUILD" = yes ]
    then
        echo "# Build $1 -> $I"
        (
            NEWID=$(guest_script "$1" | docker build -q - -t "$I")

            echo "# Push -> $I"
            [ "$DOPUSH" = yes ] && {
                lockfile /tmp/pushlock.lock
                docker push "$I" ||:
                rm -f /tmp/pushlock.lock
            }
            echo "# Done $1 -> $I = $NEWID"
        ) &

        cnt=$((cnt + 1))
        if [ "$cnt" -gt 3 ]
        then wait -n && cnt=$((cnt - 1)) ;:
        fi
    else
        echo "# Script to build $I from $1"
        guest_script "$1"
    fi
}

################################################################################
# shellcheck disable=SC1091,SC2086
guest_script() {

    [ -n "$1" ] && docker_cmd FROM "$1"

docker_start || {

main() {
    install_os
}

install_os() {
    set -e

    ID=unknown
    if [ -f /etc/os-release ]
    then . /etc/os-release
    else
        [ -f /etc/debian_version ] && {
            ID=debian
            VERSION_ID=$(cat /etc/debian_version)
            PRETTY_NAME="${PRETTY_NAME:-$ID $VERSION_ID}"
        }
    fi

    case "$ID" in
    alpine ) install_alpine; return ;;
    centos ) install_centos; return ;;
    fedora ) install_fedora; return ;;
    debian ) install_debian; return ;;
    ubuntu ) install_apt; return ;;
    opensuse*) install_opensuse; return ;;
    arch )   install_arch; return ;;
    amzn )   install_amzn; return ;;
    clear-linux-os ) install_clear_linux_os; return ;;
    esac

    echo >&2 "OS not supported: $PRETTY_NAME"
}

install_alpine() {
    echo >&2 "Installing build-base with apk for $PRETTY_NAME"
    apk add --no-cache -t build-packages \
        build-base bash bison flex lua gmp-dev openssl-dev cmake gcc-gnat
}

install_centos() {
    echo >&2 "Installing 'Development Tools' with yum for $PRETTY_NAME"
    yum groupinstall -y "Development Tools"
    yum install -y which gmp-devel openssl-devel cmake
    yum clean all
}

install_amzn() {
    echo >&2 "Installing 'Development Tools' with yum for $PRETTY_NAME"
    yum groupinstall -y "Development Tools"
    yum install -y which gmp-devel openssl-devel cmake
    yum clean all
}

install_fedora() {
    echo >&2 "Installing 'Development Tools ...' with yum for $PRETTY_NAME"
    yum groupinstall -y "C Development Tools and Libraries"
    yum install -y which gmp-devel openssl-devel cmake diffutils
    yum clean all
}

install_opensuse() {
    echo >&2 "Installing packages with zypper for $PRETTY_NAME"
    zypper install -y --type pattern devel_basis
    zypper clean -a
}

install_arch() {
    echo >&2 "Installing packages with pacman for $PRETTY_NAME"
    pacman -Syy --noconfirm --needed base-devel
    find /var/cache/pacman/pkg/ -type f -delete
}

install_clear_linux_os() {
    echo >&2 "Installing packages with swupd for $PRETTY_NAME"
    swupd bundle-add  dev-utils
}

install_debian() {
    case "$VERSION_ID" in
    5* ) fix_debian_lenny ;;
    6* ) fix_debian_squeeze ;;
    7* ) fix_debian_wheezy ;;
    esac

    install_apt
}

fix_debian_wheezy() {
cat <<\@ > /etc/apt/apt.conf.d/99unauthenticated
Acquire::Check-Valid-Until false;
// Acquire::AllowInsecureRepositories true;
// APT::Get::AllowUnauthenticated yes;
@
cat <<\@ > /etc/apt/sources.list
deb http://archive.debian.org/debian wheezy main contrib non-free
deb http://archive.debian.org/debian-security wheezy/updates main contrib non-free
@
}

fix_debian_squeeze() {
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
}

fix_debian_lenny() {
cat <<\@ > /etc/apt/apt.conf.d/99unauthenticated
Acquire::Check-Valid-Until false;
Acquire::AllowInsecureRepositories true;
APT::Get::AllowUnauthenticated yes;
@
cat <<\@ > /etc/apt/sources.list
deb http://archive.debian.org/debian/ lenny contrib main non-free
deb http://archive.debian.org/debian-security/ lenny/updates contrib main non-free
@
}

install_apt() {
    set -e
    echo >&2 "Installing build-essential and more with apt for $PRETTY_NAME"

    # Only install what we ask for.
    echo 'APT::Install-Recommends "false";' > /etc/apt/apt.conf.d/99NoRecommends

    # Auto-remove everything?
    # echo 'APT::AutoRemove::RecommendsImportant "false";' > /etc/apt/apt.conf.d/99RemoveRecommends
    # echo 'APT::AutoRemove::SuggestsImportant "false";' > /etc/apt/apt.conf.d/99RemoveSuggests

    export DEBIAN_FRONTEND=noninteractive

    apt-get update || exit

    # Howto update the keyring ...
    KR=debian-archive-keyring
    KV=$(dpkg --list $KR 2>/dev/null | awk '/^ii/{print $3;}')
    apt-get install $KR 2>/dev/null && {
    [ "$KV" != "$(dpkg --list $KR 2>/dev/null | awk '/^ii/{print $3;}')" ] &&
        apt-get update
    }

    # Make sure we're up to date.
    apt-get upgrade -y

    PKGLIST="
    build-essential

    autoconf automake beef bison bzip2 ccache debhelper flex g++-multilib
    gawk gcc-multilib gdc gnu-lightning ksh libgmp-dev libgmp3-dev
    liblua5.2-dev libluajit-5.1-dev libnetpbm10-dev libpng++-dev
    libssl-dev libtcc-dev lua-bitop lua-bitop-dev lua5.2
    luajit mawk nasm nickle pkgconf python python-dev python3 rsync ruby
    rustc tcc tcl-dev valac yasm

    csh dc default-jdk-headless gfortran gnat htop language-pack-en
    libinline-c-perl libinline-perl mono-mcs nodejs nodejs-legacy
    open-cobol php-cli php5-cli pypy python-setuptools tcsh

    "

    for PKG in \
        cmake=3.5.2-1 julia=0.3.2-2 golang=2:1.0.2-1.1 git=1:1.6 \
        libtool=1.4 locales=2.2
    do
        instver "${PKG%%=*}" "${PKG#*=}" &&
            PKGLIST="$PKGLIST ${PKG%%=*}"
    done

    FOUND=$(apt-cache show $PKGLIST 2>/dev/null | sed -n 's/^Package: //p' 2>/dev/null)

    if ! apt-mark auto gzip 2>/dev/null
    then
        # Simple way ...
        apt-get install -y $FOUND

    else
        apt-get install -y equivs

        mkdir /tmp/build
        cd /tmp/build

        cat > control <<@
Section: misc
Priority: optional
Standards-Version: 3.9.2
Package: packagelist-local
Maintainer: Your Name <yourname@example.com>
Depends: $(echo "$FOUND" | sed -e ':b;$!{;N;b b;};s/^[ \n\t]\+//;s/[ \n\t]\+$//;s/[ \n\t]\+/, /g')
Description: A list of build tools
 A list of build tools
 .
 .
@
        equivs-build control
        dpkg --unpack packagelist-local*.deb
        apt-get install -f -y
        cd
        rm -rf /tmp/build
        apt-get remove --purge -y equivs
        apt-get autoremove --purge -y
    fi

    [ -d /usr/lib/ccache ] &&
        echo "NOTE: export PATH=/usr/lib/ccache:$PATH"

    clean_apt
    return 0
}

clean_apt() {
    apt-get update -qq --list-cleanup \
        -oDir::Etc::SourceList=/dev/null
    apt-get clean
    dpkg --clear-avail; dpkg --clear-avail
    return 0
}

instver() {
    pkgname=$1
    minversion=$2
    echo "Install $pkgname >= $minversion"

    [ "$minversion" = "" ] && minversion="0"
    V=0
    for version in $(apt-cache policy "$pkgname" 2>/dev/null |
                    awk '/^  Candidate:/ {print $2;}'); do
        if dpkg --compare-versions "$version" ge "$minversion"; then
            if dpkg --compare-versions "$version" gt "$V"; then
                V=$version
            fi
        else
            echo "Found $version, older than $minversion"
        fi
    done
    [ "$V" = "0" ] && return 1
    return 0
}

main "$@"

} ; docker_commit "Install devenv"

docker_start || {

main() {
    add_userid
}

add_userid() {
    [ -x /usr/sbin/useradd ] && {
        useradd user -u 1000 -d /home/user
        return 0
    }
    [ -f /etc/alpine-release ] && {
        adduser user --uid 1000 --home /home/user -D
        return 0
    }
    [ -x /usr/sbin/adduser ] && {
        adduser user --uid 1000 --home /home/user
        return 0
    }

    useradd user -u 1000 -d /home/user
}

main "$@"

} ; docker_commit "Create user"

    docker_cmd USER user
    docker_cmd WORKDIR /home/user
    docker_cmd CMD '["bash"]'
}

################################################################################
# Dockerfile building scriptlets
#
docker_init() { RUNNOW= ; BUILD= ; DISABLE_ENCODE= ;}
docker_start() { START_LINE=$((BASH_LINENO[0]+1)) ; }
docker_commit() {
    END_LINE=$((BASH_LINENO[0]-1))
    TEXT=$(sed -n < "${BASH_SOURCE[1]}" "${START_LINE},${END_LINE}p")

    echo "$TEXT" | make_docker_runcmd "$1"
    return 0
}

docker_cmd() {
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

    * ) echo "# $*" ;;
    esac
}

make_docker_runcmd() {
    local sn="/tmp/install"
    local line

    [ "$RUNNOW" = yes ] && {
        echo ; echo '('
        cat -
        echo ')' ; echo
        return 0
    }
    [ "$DISABLE_ENCODE" = yes ] && {
        # line=$(cat); echo "RUN echo ${line@Q} >$sn;sh $sn;rm -f $sn"
        echo "RUN ${1:+: $1 ;}(\\"
        while IFS= read -r line
        do echo echo "${line@Q}" \;\\
        done
        echo ")>$sn;sh $sn;rm -f $sn"
        return 0;
    }
    # Limit per "run" is library exec arg length (approx 128k)
    # Encode the script
    echo "RUN ${1:+: $1 ;}"'set -eu; _() { echo "$@";};(\'
    gzip -cn9 | base64 -w 72 | sed 's/.*/_ &;\\/'
    echo ')|base64 -d|gzip -d>'"$sn;sh $sn;rm -f $sn"
}

################################################################################

host_main "$@"
