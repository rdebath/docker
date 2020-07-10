# Script to build quantum-espresso:latest
FROM debian as qebuild
ENV LANG=C.UTF-8
ENV PATH=/opt/conda/bin:$PATH
WORKDIR /workspace
RUN : Install Debian ;(\
echo 'set -e';\
echo 'apt-get update';\
echo 'apt-get install -y build-essential bzip2 ca-certificates curl gfortran git';\
)>/tmp/install;sh /tmp/install;rm -f /tmp/install
RUN : Download and install miniconda ;(\
echo 'set -e';\
echo 'curl -L https://repo.anaconda.com/miniconda/Miniconda3-4.5.11-Linux-x86_64.sh \';\
echo '> miniconda.sh';\
echo 'bash miniconda.sh -b -p /opt/conda';\
echo '/opt/conda/bin/conda clean -tipsy';\
echo 'ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh';\
echo 'echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc ';\
echo 'echo "conda activate base" >> ~/.bashrc';\
echo 'conda update -n base -c defaults -y conda';\
echo 'conda install -y \';\
echo 'numpy=1.16.* \';\
echo 'scipy=1.2.* \';\
echo 'joblib';\
echo 'pip install -U ase ruamel.yaml';\
echo 'conda clean -iy --all';\
)>/tmp/install;sh /tmp/install;rm -f /tmp/install
ARG QE_VER=6.5
RUN : Download ;(\
echo 'echo "Downloading qe..."';\
echo 'curl https://gitlab.com/QEF/q-e/-/archive/qe-${QE_VER}/q-e-qe-${QE_VER}.tar.bz2 |';\
echo 'tar -xj';\
echo 'echo "Downloading openmpi ..."';\
echo 'curl https://download.open-mpi.org/release/open-mpi/v4.0/openmpi-4.0.1.tar.bz2 |';\
echo 'tar -xj';\
)>/tmp/install;sh /tmp/install;rm -f /tmp/install
ARG VARIANT=latest
RUN : Install openmpi ;(\
echo 'set -e';\
echo 'if [ "$VARIANT" != openmp ]';\
echo 'then';\
echo 'echo "Install openmpi ..." && \';\
echo 'cd openmpi-4.0.1';\
echo './configure --with-cma=no';\
echo 'make -j 4';\
echo 'echo "installing..."';\
echo 'make install';\
echo 'ldconfig';\
echo 'fi';\
)>/tmp/install;sh /tmp/install;rm -f /tmp/install
RUN : Install qe ;(\
echo 'set -e';\
echo 'case "$VARIANT" in';\
echo 'openmp )  CONFIGURE_ARGS="--enable-openmp --enable-parallel=no" ;;';\
echo 'openmpi ) CONFIGURE_ARGS= ;;';\
echo '* )       CONFIGURE_ARGS="--enable-openmp" ;;';\
echo 'esac';\
echo 'echo "Building qe..."';\
echo 'cd q-e-qe-*';\
echo './configure $CONFIGURE_ARGS';\
echo 'make -j 4 pwall';\
echo 'echo "installing..."';\
echo 'make install';\
)>/tmp/install;sh /tmp/install;rm -f /tmp/install
FROM debian as quantum-espresso
ENV LANG=C.UTF-8
ENV PATH=/opt/conda/bin:$PATH
WORKDIR /workspace
RUN : Configure Linux ;(\
echo 'set -e';\
echo 'apt-get update';\
echo 'apt-get install -y libgfortran5 libgomp1';\
echo 'apt-get clean';\
echo 'apt-get update -qq --list-cleanup -oDir::Etc::SourceList=/dev/null';\
echo 'dpkg --clear-avail';\
echo 'rm -f /etc/apt/apt.conf.d/01autoremove-kernels';\
echo 'rm -f /var/log/apt/*';\
echo 'rm -f /var/lib/dpkg/*-old';\
)>/tmp/install;sh /tmp/install;rm -f /tmp/install
COPY --from=qebuild /opt/conda /opt/conda
COPY --from=qebuild /usr/local /usr/local
RUN : Complete install ;(\
echo 'mkdir -p /home/user /workspace /pseudo_dir';\
echo 'chmod 777 -R /home/user';\
echo 'chmod 777 -R /workspace';\
echo 'chmod 777 -R /pseudo_dir';\
echo 'ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh';\
echo 'echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc';\
echo 'echo "conda activate base" >> ~/.bashrc';\
echo 'ldconfig';\
)>/tmp/install;sh /tmp/install;rm -f /tmp/install
ENV OMPI_NUM=2
ENV OMP_NUM_THREADS=16
ENV ASE_ESPRESSO_COMMAND="mpiexec --bind-to socket --map-by socket -n ${OMPI_NUM} pw.x -in espresso.pwi > espresso.pwo"
ENV ESPRESSO_PSEUDO=/pseudo_dir
CMD ["bash"]

