#!/bin/sh -
#DOCKER:FROM debian
#DOCKER:USER user
#DOCKER:WORKDIR /home/user
#DOCKER:CMD ["bash"]

main() {
    install_os
    add_userid
}

add_userid() {
    [ -x /usr/sbin/useradd ] && {
	useradd user --uid 1000 --home /home/user
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

    useradd user --uid 1000 --home /home/user
}

install_os() {
    set -e

    ID=unknown
    [ -f /etc/os-release ] && . /etc/os-release || {
	[ -f /etc/debian_version ] && {
	    ID=debian
	    VERSION_ID=$(cat /etc/debian_version)
	    PRETTY_NAME="${PRETTY_NAME:-$ID $VERSION_ID}"
	}
    }

    case "$ID" in
    alpine ) install_alpine; return ;;
    centos ) install_centos; return ;;
    fedora ) install_fedora; return ;;
    debian ) install_debian; return ;;
    ubuntu ) install_apt; return ;;
    opensuse*) install_opensuse; return ;;
    arch )   install_arch; return ;;
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
    pacman -Syy --noconfirm --needed base-devel
    find /var/cache/pacman/pkg/ -type f -delete
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
    echo >&2 "Installing build-essential and more with apt for $PRETTY_NAME"

    # Only install what we ask for.
    echo 'APT::Install-Recommends "false";' > /etc/apt/apt.conf.d/99NoRecommends

    # Auto-remove everything?
    # echo 'APT::AutoRemove::RecommendsImportant "false";' > /etc/apt/apt.conf.d/99RemoveRecommends
    # echo 'APT::AutoRemove::SuggestsImportant "false";' > /etc/apt/apt.conf.d/99RemoveSuggests

    export DEBIAN_FRONTEND=noninteractive

    apt-get update || exit

    # Howto update the keyring ...
    KV=`dpkg --list debian-archive-keyring | awk '/^ii/{print $3;}'`
    apt-get install debian-archive-keyring ||:
    apt-mark auto debian-archive-keyring ||:
    [ "$KV" != "`dpkg --list debian-archive-keyring | awk '/^ii/{print $3;}'`" ] &&
	apt-get update

    # Make sure we're up to date.
    apt-get dist-upgrade -y

    PKGLIST="
    build-essential

    autoconf automake beef bison bzip2 ccache debhelper flex g++-multilib
    gawk gcc-multilib gdc gnu-lightning ksh libgmp-dev libgmp3-dev
    liblua5.2-dev libluajit-5.1-dev libnetpbm10-dev libpng++-dev
    libssl-dev libtcc-dev libtool locales lua-bitop lua-bitop-dev lua5.2
    luajit mawk nasm nickle pkgconf python python-dev python3 rsync ruby
    rustc tcc tcl-dev valac yasm

    csh dc default-jdk-headless gfortran gnat htop language-pack-en
    libinline-c-perl libinline-perl mono-mcs nodejs nodejs-legacy
    open-cobol php-cli php5-cli pypy python-setuptools tcsh

    "

    for PKG in \
	cmake=3.5.2-1 julia=0.3.2-2 golang=2:1.0.2-1.1 git=1:1.6
    do
	instver "${PKG%%=*}" "${PKG#*=}" &&
	    PKGLIST="$PKGLIST ${PKG%%=*}"
    done

    FOUND=`apt-cache show $PKGLIST | sed -n 's/^Package: //p' 2>/dev/null`

    # Simple way ...
    # apt-get install -y $FOUND

    apt-get install -y equivs

    mkdir /tmp/build
    cd /tmp/build

    cat > control <<@
Section: misc
Priority: optional
Standards-Version: 3.9.2
Package: packagelist-local
Depends: $(echo "$FOUND" | sed -e ':b;$!{;N;b b;};s/^[ \n\t]\+//;s/[ \n\t]\+$//;s/[ \n\t]\+/, /g')
Description: A list of build tools
 A list of build tools
 .
 .
@
    equivs-build control
    dpkg -i --force-depends *.deb 2>/dev/null # It complains about the force
    apt-get install -f -y
    cd
    rm -rf /tmp/build
    apt-get remove --purge -y equivs
    apt-get autoremove --purge -y

    [ -d /usr/lib/ccache ] &&
	echo export PATH=/usr/lib/ccache:$PATH

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
    for version in `apt-cache policy $pkgname 2>/dev/null |
		    awk '/^  Candidate:/ {print $2;}'`; do
	if dpkg --compare-versions $version ge $minversion; then
	    if dpkg --compare-versions $version gt $V; then
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

