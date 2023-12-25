#!/bin/bash -
if [ ! -n "$BASH_VERSION" ];then if [ "`which 2>/dev/null bash`" != "" ];then exec bash "$0" "$@"; fi ; fi

set -e

PAR=-j$(( ($(grep -c ^processor /proc/cpuinfo)*3+1)/2 ))

# export https_proxy=http://10.13.72.1:8888
# export http_proxy=http://10.13.72.1:8888

# CMAKEVSN=2.8.12.2	# LLVM 3.8.0 +

# CMAKEVSN=3.4.3 	# LLVM 3.9.0 +

CMAKEVSN=3.13.4		# Debian Buster
LLVMVSN=10.0.0

[ "$1" = "-nrt" ] && { NOCOMPRT=yes ; shift ; }

[ "$2" != "" ] && CMAKEVSN="$2"
[ "$1" != "" ] && LLVMVSN="$1"

LLD= ; OPENMP=

main()
{
    setup_prg
    fetch_clang

    build_cmake
    build_clang

    build_clang2

    exit 0
}

setup_prg() {

    FAKEROOT=
    if [ `id -u` -ne 0 ]
    then SUDO=sudo
	 FAKEROOTPKG=fakeroot
    else SUDO=
	 FAKEROOTPKG=
    fi

    if [ `getconf LONG_BIT` = 32 -a `uname -m` = x86_64 ]
    then I386=i386
    else I386=
    fi

    set -v
    $SUDO id

    $SUDO apt-get --no-install-recommends install -y \
	    build-essential curl sudo ca-certificates \
	    libncurses5-dev libcurl4-openssl-dev libelf-dev \
	    libncurses5 libtinfo5 wget xz-utils \
	    git python alien $FAKEROOTPKG ||:

    $SUDO apt-get --no-install-recommends install -y cmake ||:

    # Dont use distribution versions
    $SUDO apt-get remove --purge clang -y ||:
    # $SUDO apt-get remove --purge emacsen-common samba-common libarchive12 libarchive13 libnettle4 libxmlrpc-core-c3 ||:

    RC=`which cmake ||:`
    [ "$RC" != "" -a -x "$RC" ] && {
	DEBCMAKEVER=$(cmake --version |awk '/^cmake/{print $NF;}')

	if ! dpkg --compare-versions "$DEBCMAKEVER" eq "${CMAKEVSN}"
	then
	    # Distribution versions are too old.
	    if [ "$RC" = /usr/bin/cmake ]
	    then $SUDO apt-get remove --purge cmake cmake-data -y ||:
	    else $SUDO apt-get remove --purge cmake-local -y ||:
	    fi
	fi
    }

    RC=`which cmake ||:`
    [ "$RC" != "" -a -x "$RC" ] || {
	CMDEB="$HOME/deb/cmake-local_${CMAKEVSN}-1_$(dpkg --print-architecture).deb"
	if [ -f "$CMDEB" ]
	then $SUDO dpkg -i "$CMDEB"
	fi
    }

    LLVMMINOR="${LLVMVSN%.[0-9]*}"
    LLVMINST="/usr/local/lib/llvm-$LLVMMINOR"
    export PATH="${LLVMINST}/bin:$PATH"

    LLVMPRIO=$(echo $LLVMMINOR | tr -d . )
}

build_cmake() {

    RC=`which cmake ||:`
    [ "$RC" != "" -a -x "$RC" ] && return 0

    [ -d cmake ] ||
	git clone https://gitlab.kitware.com/cmake/cmake.git
	# https://cmake.org/cmake.git

    cd cmake
    git checkout -f v$CMAKEVSN

    $I386 sh bootstrap
    $I386 make $PAR

    DD="$(pwd)/build"

    if [ `id -u` -ne 0 ]
    then FAKEPERM=/tmp/faked.stat
	 rm -f $FAKEPERM
	 FAKEROOT="fakeroot -s $FAKEPERM -i $FAKEPERM"
	 fakeroot -s $FAKEPERM pwd
    fi

    mkdir -p "$DD"/usr/local
    $FAKEROOT chown -R root:staff "$DD"/usr/local
    $FAKEROOT chmod 2775 "$DD"/usr/local
    $FAKEROOT $I386 make install/strip DESTDIR="$DD"
    mkdir -p $HOME/deb
    PGM=cmake
    PGMU="${PGM}_local"
    PGMM="${PGM}-local"
    ARCH=`dpkg --print-architecture`
    (   cd "$DD" &&
	$FAKEROOT tar cf ${PGMU}-$CMAKEVSN.tgz usr/local/*/* &&
	$FAKEROOT alien --to-deb --nopatch -k --target=$ARCH \
	    --version=$CMAKEVSN ${PGMU}-$CMAKEVSN.tgz &&
	$SUDO dpkg -i ${PGMM}_$CMAKEVSN-1_$ARCH.deb &&
	mv ${PGMM}_$CMAKEVSN-1_$ARCH.deb $HOME/deb/.
    )
    rm -rf "$DD" ||:

    cd ..
}

fetch_clang() {
    case "$LLVMVSN" in
    [3456].* )
	    VSN=$LLVMVSN
	    LLVMBASE=http://llvm.org/releases/$VSN
	    CFE=cfe
	    ;;
    7.0.*|[89].0.0 )
	    VSN=$LLVMVSN
	    LLVMBASE=http://llvm.org/releases/$VSN
	    CFE=cfe
	    ;;
    [78].* )
	    VSN=$LLVMVSN
	    LLVMBASE=https://github.com/llvm/llvm-project/releases/download/llvmorg-$VSN
	    CFE=cfe
	    ;;
    9.0.1|10.0.0 )
	    VSN=$LLVMVSN
	    LLVMBASE=https://github.com/llvm/llvm-project/releases/download/llvmorg-$VSN
	    CFE=clang
	    ;;
    * )
	    echo FAIL $LLVMVSN >&2
	    exit 1
    esac

    LLVM=$LLVMBASE/llvm-$VSN.src.tar.xz
    CLANG=$LLVMBASE/$CFE-$VSN.src.tar.xz
    OPENMP=$LLVMBASE/openmp-$VSN.src.tar.xz
    [ "$NOCOMPRT" != yes ] &&
	COMPRT=$LLVMBASE/compiler-rt-$VSN.src.tar.xz
#   LLD=$LLVMBASE/lld-$VSN.src.tar.xz

    echo LLVM $VSN ...
    [ -f `basename $LLVM` ] || wget $LLVM
    [ -f `basename $CLANG` ] || wget $CLANG
    [ "$OPENMP" != '' ] && {
	[ -f `basename $OPENMP` ] || wget $OPENMP
    }
    [ "$COMPRT" != '' ] && {
	[ -f `basename $COMPRT` ] || wget $COMPRT
    }
    [ "$LLD" != '' ] && {
	[ -f `basename $LLD` ] || wget $LLD
    }

    BD=build.llvm1.$VSN
    SD=build.src.$VSN
    TSD=build.src
    DD="$(pwd)/build.install.$VSN"

    [ -d $SD ] || {
	rm -rf "$TSD" ||:

	echo Extracting LLVM
	tar --no-same-owner --no-same-permissions -xf `basename $LLVM`
	mv `basename $LLVM .tar.xz` $TSD

	echo Extracting CLANG
	tar --no-same-owner --no-same-permissions -xf `basename $CLANG`
	mv `basename $CLANG .tar.xz` $TSD/tools/clang

	[ "$LLD" != '' ] && {
	    echo Extracting LLD
	    tar --no-same-owner --no-same-permissions -xf `basename $LLD`
	    mv `basename $LLD .tar.xz` $TSD/tools/lld
	}

	[ "$OPENMP" != '' ] && {
	    echo Extracting OPENMP
	    tar --no-same-owner --no-same-permissions -xf `basename $OPENMP`
	    mv `basename $OPENMP .tar.xz` $TSD/projects/openmp
	}

	[ "$COMPRT" != '' ] && {
	    echo Extracting COMPRT
	    tar --no-same-owner --no-same-permissions -xf `basename $COMPRT`
	    mv `basename $COMPRT .tar.xz` $TSD/projects/compiler_rt
	}

	mv "$TSD" $SD || exit
    }
}

build_clang() {

    RC=`which clang ||:`
    RC2=`which llvm-config ||:`
    [ "$RC" != "" -a -x "$RC" -a "$RC2" != "" -a -x "$RC2" ] || {

	[ -d $BD ] ||
	    mkdir -p $BD

	[ -x $BD/bin/llvm-config ] || {
	    echo Building LLVM
	    cd $BD
	    $I386 cmake \
		    -DCMAKE_BUILD_TYPE=release \
		    -DCMAKE_INSTALL_PREFIX="$LLVMINST" \
		    -DLLVM_ENABLE_LTO=off \
		    ../$SD
	    $I386 make $PAR
	    cd ..
	}

	echo Installing LLVM
	cd $BD

	if [ `id -u` -ne 0 ]
	then FAKEPERM=/tmp/faked.stat
	     rm -f $FAKEPERM
	     FAKEROOT="fakeroot -s $FAKEPERM -i $FAKEPERM"
	     fakeroot -s $FAKEPERM pwd
	fi

	mkdir -p "$DD"/usr/local
	$FAKEROOT chown -R root:staff "$DD"/usr/local
	$FAKEROOT chmod 2775 "$DD"/usr/local
	echo Creating builddir
	$FAKEROOT $I386 make install/strip DESTDIR="$DD"

	create_scripts

	echo Creating deb file
	mkdir -p $HOME/deb
	PGM=clang
	PGMU="${PGM}_${LLVMMINOR}_local"
	PGMM="${PGM}-${LLVMMINOR}-local"
	ARCH=`dpkg --print-architecture`
	(   cd "$DD" &&
	    $FAKEROOT tar cf ${PGMU}.tgz usr/local/*/* &&
	    $FAKEROOT alien --to-deb --nopatch -k --target=$ARCH \
		--version=$VSN ${PGMU}.tgz &&
	    $SUDO dpkg -i ${PGMM}_$VSN-1_$ARCH.deb &&
	    mv ${PGMM}_$VSN-1_$ARCH.deb $HOME/deb/.
	)
	rm -rf "$DD" ||:

	cd ..
    }
    unset RC RC2 VSN LLVMBASE LLVM CLANG OPENMP COMPRT LLD BD SD DD PGM ARCH
}

build_clang2() {

	VSN=$LLVMVSN
	BD=build.llvm2.${VSN}
	SD="$(pwd)/build.src.$VSN"
	DD="$(pwd)/build.install2.$VSN"
	PGM=clang
	PGMU="${PGM}_${LLVMMINOR}_local"
	PGMM="${PGM}-${LLVMMINOR}-local"
	ARCH=`dpkg --print-architecture`

#	[ -f "$HOME/deb/${PGMM}_$VSN-2_$ARCH.deb" ] && {
#	    $SUDO dpkg -i "$HOME/deb/${PGMM}_$VSN-2_$ARCH.deb" &&
#		return
#	}

	clang -v || exit 2;

	mkdir -p $BD

	[ -x $BD/bin/llvm-config ] || {
	    echo Building LLVM2
	    cd $BD
	    if [ `getconf LONG_BIT` = 32 ]
	    then
		$I386 cmake \
		    -DCMAKE_BUILD_TYPE=release \
		    -DCMAKE_INSTALL_PREFIX="$LLVMINST" \
		    -DLLVM_ENABLE_LTO=off \
		    -DCMAKE_CXX_COMPILER=clang++ \
		    -DCMAKE_C_COMPILER=clang \
		    "$SD"
	    else
		$I386 cmake \
		    -DCMAKE_BUILD_TYPE=release \
		    -DCMAKE_INSTALL_PREFIX="$LLVMINST" \
		    -DCMAKE_CXX_COMPILER=clang++ \
		    -DCMAKE_C_COMPILER=clang \
		    "$SD"
	    fi
	    $I386 make $PAR
	    cd ..
	}

	echo Installing LLVM2
	cd $BD

	if [ `id -u` -ne 0 ]
	then FAKEPERM=/tmp/faked.stat
	     rm -f $FAKEPERM
	     FAKEROOT="fakeroot -s $FAKEPERM -i $FAKEPERM"
	     fakeroot -s $FAKEPERM pwd
	fi

	mkdir -p "$DD"/usr/local
	# mkdir -p "$DD"/usr/local/{bin,lib,include,share,libexec}
	$FAKEROOT chown -R root:staff "$DD"/usr/local
	$FAKEROOT chmod 2775 "$DD"/usr/local
	echo Creating builddir
	$FAKEROOT $I386 make install/strip DESTDIR="$DD"

	create_scripts

	echo Creating deb file
	mkdir -p $HOME/deb
	(   cd "$DD" &&
	    $FAKEROOT tar cf ${PGMU}.tgz usr/local/*/* install &&
	    $FAKEROOT alien --to-deb --nopatch --target=$ARCH \
		--scripts --bump=1 --version=$VSN ${PGMU}.tgz &&
	    $SUDO dpkg -i ${PGMM}_$VSN-2_$ARCH.deb &&
	    mv ${PGMM}_$VSN-2_$ARCH.deb $HOME/deb/.
	)
	rm -rf "$DD" ||:

	cd ..

}

create_scripts() {

mkdir -p "$DD"/install
cat > "$DD"/install/doinst.sh <<\!
#!/bin/sh

ABIN=/usr/local/bin
!
echo ALIB=/usr/local/lib/llvm-$LLVMMINOR/bin >> "$DD"/install/doinst.sh

cat >> "$DD"/install/doinst.sh <<\!
set -e
case "$1" in
    configure)
        update-alternatives --quiet --install \
	    "$ABIN"/clang local-clang "$ALIB"/clang \
!
echo '		'$LLVMPRIO' \' >> "$DD"/install/doinst.sh

for prg in \
	clang++ clang-query pp-trace clang-tidy clang-apply-replacements \
	c-index-test clang-tblgen clang-check scan-build scan-view \
	asan_symbolize opt macho-dump llvm-tblgen llvm-size llvm-rtdyld \
	llvm-ranlib llvm-prof llvm-objdump llvm-nm llvm-mc llvm-link \
	llvm-ld llvm-extract llvm-dwarfdump llvm-dis llvm-diff llvm-cov \
	llvm-config llvm-bcanalyzer llvm-as llvm-ar llc bugpoint
do
    echo '    --slave "$ABIN"/'$prg' local-'$prg' "$ALIB"/'$prg' \' \
	>> "$DD"/install/doinst.sh
done

cat >> "$DD"/install/doinst.sh <<\!
    ;;
esac
exit 0
!


cat > "$DD"/install/predelete.sh <<\!
#!/bin/sh

set -e

case "$1" in
    remove|upgrade|deconfigure)
        update-alternatives --quiet --remove local-clang \
!
echo "		/usr/local/lib/llvm-$LLVMMINOR/bin/clang" \
	 >> "$DD"/install/predelete.sh
cat >> "$DD"/install/predelete.sh <<\!
        ;;
esac
exit 0
!

}

main "$@"
