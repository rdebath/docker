#!/usr/bin/env bash
# shellcheck disable=SC1003,SC2001,SC2016
#
if [ -z "$BASH_VERSION" ];then exec bash "$0" "$@";else set +o posix;fi
set -e

host_main() {
    docker_init
    REPOPREFIX=
    DOPUSH=
    DISABLE_ENCODE=yes
    while [ "${1#-}" != "$1" ]
    do
	case "$1" in
	# Runnable, output a shell script runnable in the guest
	-r ) RUNNOW=yes ; shift ;;
	# Build, feed the dockerfile into docker build
	-b ) BUILD=yes ; shift ;;
	# Disable base64 encoding
	-X ) DISABLE_ENCODE= ; shift ;;

	-R ) REPOPREFIX="${2:+$2/}" ; shift 2;;
	-P ) DOPUSH=yes; shift;;

	* ) echo >&2 "Unknown Option $1" ; exit 1;;
	esac
    done

    [ "$#" -eq 0 ] && set -- latest openmp openmpi
    for i
    do build_one "$i"
    done
    wait
}

build_one() {
    local I
    I="$(echo :"$1"- | tr ':/' '--' | tr -d . | \
	sed -e 's/-latest-/-/' \
	    -e 's/-localhost-/-/' \
	    -e 's/^-//' -e 's/-$//' )"

    [ "$I" = '' ] && I="$1"
    I="${REPOPREFIX}quantum-espresso:$I"

    if [ "$BUILD" = yes ]
    then
	echo "# Build $1 -> $I"
	guest_script "$1" | docker build - -t "$I"
	echo "# Build done $1 -> $I"

	[ "$DOPUSH" = yes ] && {
	    echo "# Pushing -> $I"
	    docker push "$I" ||:
	    echo "# Push done -> $I"
	}
    else
	echo "# Script to build $I"
	guest_script "$1"
    fi
    :
}

################################################################################
# shellcheck disable=SC1091,SC2086
guest_script() {

    docker_cmd FROM debian as qebuild
    docker_cmd ENV 'LANG=C.UTF-8'
    docker_cmd ENV 'PATH=/opt/conda/bin:$PATH'
    docker_cmd WORKDIR '/workspace'

    # Setup
    docker_start || {
	set -e
	apt-get update
	apt-get install -y build-essential bzip2 ca-certificates curl gfortran git
    } ; docker_commit "Install Debian"

    docker_start || {
	set -e

	curl -L https://repo.anaconda.com/miniconda/Miniconda3-4.5.11-Linux-x86_64.sh \
	    > miniconda.sh
	bash miniconda.sh -b -p /opt/conda

	/opt/conda/bin/conda clean -tipsy
	ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh

	echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc 
	echo "conda activate base" >> ~/.bashrc

	conda update -n base -c defaults -y conda
	conda install -y \
	    numpy=1.16.* \
	    scipy=1.2.* \
	    joblib

	    # pandas=0.24.* \

	pip install -U ase ruamel.yaml
	conda clean -iy --all

    } ; docker_commit "Download and install miniconda"

    # docker_cmd ARG 'QE_VER=6.4.1'
    docker_cmd ARG 'QE_VER=6.5'

    docker_start || {
	echo "Downloading qe..."
	curl https://gitlab.com/QEF/q-e/-/archive/qe-${QE_VER}/q-e-qe-${QE_VER}.tar.bz2 |
	    tar -xj

	echo "Downloading openmpi ..."
	curl https://download.open-mpi.org/release/open-mpi/v4.0/openmpi-4.0.1.tar.bz2 |
	    tar -xj

    } ; docker_commit "Download"

    docker_cmd ARG VARIANT=$1

    if [ "$1" != openmp ]
    then
	docker_start || {
	    set -e

	    if [ "$VARIANT" != openmp ]
	    then
		echo "Install openmpi ..." && \
		cd openmpi-4.0.1
		./configure --with-cma=no
		make -j 4
		echo "installing..."
		make install
		ldconfig
	    fi

	} ; docker_commit "Install openmpi"
    fi

    docker_start || {
	set -e

	case "$VARIANT" in
        openmp )  CONFIGURE_ARGS="--enable-openmp --enable-parallel=no" ;;
        openmpi ) CONFIGURE_ARGS= ;;
        * )       CONFIGURE_ARGS="--enable-openmp" ;;
	esac

	echo "Building qe..."
	cd q-e-qe-*
	./configure $CONFIGURE_ARGS
	make -j 4 pwall
	echo "installing..."
	make install
    } ; docker_commit "Install qe"

    docker_cmd FROM debian as quantum-espresso
    docker_cmd ENV 'LANG=C.UTF-8'
    docker_cmd ENV 'PATH=/opt/conda/bin:$PATH'
    docker_cmd WORKDIR '/workspace'

    docker_start || {
	set -e

	apt-get update
	apt-get install -y libgfortran5 libgomp1
	apt-get clean
	apt-get update -qq --list-cleanup -oDir::Etc::SourceList=/dev/null
	dpkg --clear-avail
	rm -f /etc/apt/apt.conf.d/01autoremove-kernels
	rm -f /var/log/apt/*
	rm -f /var/lib/dpkg/*-old

    } ; docker_commit 'Configure Linux'

    docker_cmd COPY '--from=qebuild /opt/conda /opt/conda'
    docker_cmd COPY '--from=qebuild /usr/local /usr/local'

    docker_start || {
	# make working dirs
	mkdir -p /home/user /workspace /pseudo_dir
	chmod 777 -R /home/user
	chmod 777 -R /workspace
	chmod 777 -R /pseudo_dir

	ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh
	echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc
	echo "conda activate base" >> ~/.bashrc
	ldconfig
    } ; docker_commit 'Complete install'

    case "$1" in
    openmp )
	docker_cmd ENV 'OMP_NUM_THREADS=8'
	docker_cmd ENV 'ASE_ESPRESSO_COMMAND="pw.x -in espresso.pwi > espresso.pwo"'
	;;
    openmpi )
	docker_cmd ENV 'OMPI_NUM=4'
	docker_cmd ENV 'ASE_ESPRESSO_COMMAND="mpiexec -n ${OMPI_NUM} pw.x -in espresso.pwi > espresso.pwo"'
	;;
    * )
	docker_cmd ENV 'OMPI_NUM=2'
	docker_cmd ENV 'OMP_NUM_THREADS=16'
	docker_cmd ENV 'ASE_ESPRESSO_COMMAND="mpiexec --bind-to socket --map-by socket -n ${OMPI_NUM} pw.x -in espresso.pwi > espresso.pwo"'
	;;
    esac

    docker_cmd ENV 'ESPRESSO_PSEUDO=/pseudo_dir'
    docker_cmd CMD '["bash"]'
    docker_cmd
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

    '') ;;
    * ) echo "# $*" ;;
    esac
}

make_docker_runcmd() {
    local sn="/tmp/install"
    local line

    [ "$RUNNOW" = yes ] && {
	echo '('
	cat -
	echo ')'
	return 0
    }
    [ "$DISABLE_ENCODE" = yes ] && {
	# Note the sed command might break your script; maybe.
	# It reduces the size of the Dockerfile and if in DISABLE_ENCODE mode
	# significantly reduces the occurance of $'...' strings.
	echo "RUN ${1:+: $1 ;}(\\"
	sed -e 's/^[\t ]\+//' -e 's/^#.*//' -e '/^$/d' |
	    while IFS= read -r line
	    do echo echo "${line@Q};"\\
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
