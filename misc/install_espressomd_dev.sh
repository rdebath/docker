#!/bin/sh -

main() {
    set -e

    [ -z "${1#1}" ] && useradd -m espresso -u 1000
    [ -z "${1#2}" ] && install_os
    [ -z "${1#3}" ] && install_scafacos
}

install_scafacos() {
    set -e

    cd /tmp
    git clone --recursive git://github.com/scafacos/scafacos --branch dipoles
    cd scafacos
    ./bootstrap
    ./configure --enable-shared --enable-portable-binary \
	    --with-internal-pfft --with-internal-pnfft \
	    --enable-fcs-solvers=direct,pnfft,p2nfft,p3m \
	    --disable-fcs-fortran --enable-fcs-dipoles
    make -j `nproc`
    make install
    cd
    rm -rf /tmp/scafacos
    ldconfig
}

install_os() {
    set -e

    [ -f /etc/os-release ] && . /etc/os-release
    case "$ID" in
    # alpine ) install_alpine; return ;;
    centos ) install_centos; return ;;
    fedora ) install_fedora; return ;;
    ubuntu ) install_ubuntu; return ;;
    debian ) install_debian; return ;;
    opensuse-leap ) install_opensuse_leap; return ;;
    esac

    echo >&2 "OS not supported: $PRETTY_NAME"
    exit 2
}

install_alpine() {
    apk add --no-cache -t build-packages \
	build-base bison flex lua gmp-dev openssl-dev cmake gcc-gnat
}

install_centos() {
    yum -y install epel-release
    yum -y install \
	blas-devel boost169-devel boost169-openmpi-devel ccache \
	cmake3 fftw-devel gdb git hdf5-openmpi-devel lapack-devel \
	make openmpi-devel python36 python36-Cython python36-devel \
	python36-numpy python36-pip python36-scipy python36-setuptools \
	vim which zlib-devel
    yum clean all
    ln -s /usr/bin/cmake3 /usr/bin/cmake

export BOOST_INCLUDEDIR=/usr/include/boost169
export BOOST_LIBRARYDIR=/usr/lib64/boost169

    ln -s /usr/lib64/openmpi/lib/boost169/libboost_mpi.so \
	/usr/lib64/boost169/libboost_mpi.so

    pip3 install --user h5py
}

install_fedora() {
    yum -y install \
	blas-devel boost-devel boost-openmpi-devel ccache cmake \
	fftw-devel gcc gcc-c++ gdb git hdf5-openmpi-devel lapack-devel \
	make openmpi-devel python3 python3-Cython python3-devel \
	python3-h5py python3-numpy python3-pip python3-scipy \
	python3-setuptools vim which zlib-devel
    yum clean all
}

install_opensuse_leap() {
    ln -s /usr/sbin/update-alternatives /usr/bin
    zypper -n --gpg-auto-import-keys refresh
    zypper -n --gpg-auto-import-keys install \
	Modules blas-devel ccache cmake curl fftw3-devel \
	gcc-c++ gdb git hdf5-openmpi-devel-static lapack-devel \
	libboost_filesystem1_66_0-devel libboost_mpi1_66_0-devel \
	libboost_serialization1_66_0-devel libboost_test1_66_0-devel \
	libhdf5-103-openmpi2 python3 python3-Cython python3-h5py \
	python3-numpy python3-numpy-devel python3-pip python3-scipy \
	python3-setuptools vim which
}

install_debian() {
    export DEBIAN_FRONTEND=noninteractive
    apt-get update
    apt-get install -y \
	apt-utils build-essential ccache cmake cython3 gdb git \
	libblas-dev libboost-dev libboost-filesystem-dev libboost-mpi-dev \
	libboost-serialization-dev libboost-test-dev libfftw3-dev \
	libgsl-dev libhdf5-openmpi-dev liblapack-dev libpython3-dev \
	openmpi-bin python3 python3-h5py python3-numpy python3-pip \
	python3-scipy python3-setuptools python3-vtk7 vim

    apt-get clean
    apt-get update -qq --list-cleanup -oDir::Etc::SourceList=/dev/null
}

install_ubuntu() {
    export DEBIAN_FRONTEND=noninteractive
    export NVIDIA_VISIBLE_DEVICES=all
    export NVIDIA_DRIVER_CAPABILITIES=compute,utility

    PKGLIST='
	apt-utils autoconf automake build-essential ccache
	cmake curl cython3 gfortran gdb git jq lcov libblas-dev
	libboost-dev libboost-serialization-dev libboost-mpi-dev
	libboost-filesystem-dev libboost-test-dev libfftw3-dev libgsl-dev
	libhdf5-openmpi-dev liblapack-dev libopenmpi-dev libtool
	openmpi-bin openssh-client pkg-config python3 python3-dev
	python3-numpy python3-numpydoc python3-scipy python3-h5py
	python3-pip python3-lxml python3-requests python3-setuptools
	python3-vtk7 rsync vim
    '
    case "$VERSION_CODENAME" in
    bionic ) install_ubuntu_bionic; return ;;
    focal ) install_ubuntu_focal; return ;;
    * )
	echo >&2 "OS not supported: $PRETTY_NAME"
	exit 2
	;;
    esac
}

install_ubuntu_bionic() {
    apt-get update
    apt-get install --no-install-recommends -y \
	libthrust-dev nvidia-cuda-toolkit \
	$PKGLIST

    apt-get clean
    apt-get update -qq --list-cleanup -oDir::Etc::SourceList=/dev/null
}

install_ubuntu_focal() {
    apt-get update
    apt-get install --no-install-recommends -y \
	libthrust-dev nvidia-cuda-toolkit \
	$PKGLIST \
	clang-9 clang-format-9 clang-tidy-9 doxygen ffmpeg g++-8 g++-9 \
	gcc-8 gcc-9 graphviz ipython3 jupyter-nbconvert jupyter-notebook \
	llvm-9 python3-lxml python3-matplotlib texlive-base

    apt-get clean
    apt-get update -qq --list-cleanup -oDir::Etc::SourceList=/dev/null
}

main "$@"

