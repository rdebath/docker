# Dockerfile to build quantum-espresso:latest
#--------------------------------------------------------------------------#
FROM debian as build-base
ENV LANG=C.UTF-8
ENV PATH=/opt/conda/bin:$PATH
WORKDIR /workspace
RUN : Install Debian ;set -e;_() { echo "$@";};(\
_ H4sIAAAAAAACAzXLsQ3AIAwF0Rqm+AvQZJ40BgyyZBFkTJFMnzS57hUXaHrq7NizknMMv2Us;\
_ J1WkG3mL1sRr8XAhxRkDvvIj80ChVNhcmpTvXyjbFL1d5kYDXRxNlOML/FWm+GgAAAA=;\
)|base64 -d|gzip -d>/tmp/install;sh -e /tmp/install;rm -f /tmp/install

#--------------------------------------------------------------------------#
FROM build-base AS qedownload
ARG QE_VER=6.7MaX
ARG MPI_VER=4.0
ARG MPI_BLD=5

RUN : Download qe and mpi ;set -e;_() { echo "$@";};(\
_ H4sIAAAAAAACA3WOwQqCQBCGz+5TLOJ1Z6Bjx9AgKMiCrrGugxqrq6tZZL17ikZBOKeZb35m;\
_ PodUarjrm1uhjYyzIuEVAYDLHHW1mov6yNOmKeslYpI1WkagTI5hsMZKEAqUVqVZS1iR8Low;\
_ OJ+Cw2tYiV8AjbQQPRb8yRzeVz9ycb8w5vy/NyUVeZnxGYl4isKQE30QjE3QkiZZE34gtl63;\
_ 229Gm+mi+CIY29XWn1V7A5Dy5u0ZAQAA;\
)|base64 -d|gzip -d>/tmp/install;sh -e /tmp/install;rm -f /tmp/install

#--------------------------------------------------------------------------#
FROM build-base AS condabuild
RUN : Download and install miniconda ;set -e;_() { echo "$@";};(\
_ H4sIAAAAAAACA4VQQU7DMBA8268Y9b62KkqFOOQF5cQVCTmOqxg5thXbqLnwdpxAQouE8MU7;\
_ szOj3WW6jA6UnkEn9DnH9CjlaGIQyisdfKeEDoMcrLcLkk9rdUcHcS/2ezpZXy50eTi+Hg8i;\
_ 9XjhDPU12EyV5axVtXdNgVpQhAwxy4XjnC0/tDPKg7KNaeLM1TJdyaTJWsYxnK0zopNb3B98;\
_ TTW6D9iJ/zN2aBp8SDHPOmqszq+plM72XWWD2jW3ym3yErtZQX4RgTQ6c1bF5QSacLul9Skr;\
_ 5+bG98l8GeIGkrY/IKrqSCt6C62z7e9z2QlENZB/AvcQhrDUAQAA;\
)|base64 -d|gzip -d>/tmp/install;sh -e /tmp/install;rm -f /tmp/install

#--------------------------------------------------------------------------#
FROM qedownload AS qebuild

ARG VARIANT=latest

RUN : Install openmpi ;set -e;_() { echo "$@";};(\
_ H4sIAAAAAAACAz2OQQ6CMBBF1+0pxoYQNWk9AQuWbFwY40ZdNKXQwXZKsMbrWwI4u///y8sw;\
_ yIcd3EEUt/rS1OergF0FcbQURnhyNgPJWeKMWeMiiIbeSXu/IghKKQFlCY9MmHar5TFHdTKR;\
_ Ouw/kwUpv5icNEFXFPMW9CuXAxR7GqdoDn8/Ln6kfjZv5Nrm6NtFurzWIf8BMQYPcMQAAAA=;\
)|base64 -d|gzip -d>/tmp/install;sh -e /tmp/install;rm -f /tmp/install
RUN : Install qe ;set -e;_() { echo "$@";};(\
_ H4sIAAAAAAACA4WPTU/DMAyGz8mvsEKlsUkJd6ZNCmhMk0qHSuGKstQbYZmTtgz+PqH7kMYF;\
_ X+zXth6/ZtZ0CCJ71eVCF5UAR5yFiLSLMAS4XxYPi/lLOXvT5fx5IqREMiuP8rhy1tG0xnv0;\
_ EwoCxuMTwyXIH0Y/Hf3C+/jnwgGGnbE8JfseQNztna8dbaBBpZTgzNbQSJQNyhFn6sYGWrvN;\
_ vkXILuEnwkAVy+pJlzrPZ/ktXEEVInj8Qg81pqs1knXYgUmIVRu2SGoA0yk8mi2unUfOdqkC;\
_ +QHZNcU22CHE7/T92aGj7jPp5PFgsF8/NvkPToVDsXIBAAA=;\
)|base64 -d|gzip -d>/tmp/install;sh -e /tmp/install;rm -f /tmp/install

#--------------------------------------------------------------------------#
FROM debian as quantum-espresso
ENV LANG=C.UTF-8
ENV PATH=/opt/conda/bin:$PATH
WORKDIR /workspace
RUN : Configure Linux ;set -e;_() { echo "$@";};(\
_ H4sIAAAAAAACA1WNPW7DMAyFZ/sUmgMwqocsBrq1W7ecgJFoQwgtKjRloLeP7SA1OnB4Px9f;\
_ g8VgJHO1RDRqm7dOeTZkdvDrON3GQdQU82UXMpXuaAYmzId8PXLweDgATrPBXqjFgXwl7ftv;\
_ C31/laqBftb400dafK7MbRPLfVypDVDABdPq6eRgcJ4s+HViu3OQPJyj/+iwmihNshDcSTPx;\
_ /NdfUD3LuDOn/266+W3In0A4tk9QFew+AgEAAA==;\
)|base64 -d|gzip -d>/tmp/install;sh -e /tmp/install;rm -f /tmp/install
COPY --from=condabuild /opt/conda /opt/conda
COPY --from=qebuild /usr/local /usr/local
RUN : Complete install ;set -e;_() { echo "$@";};(\
_ H4sIAAAAAAACA4WMQQ7CIBRE13CKSV2Xv+yuh/ACBuG3kJZCoOrOs4saTdPEuJpk3psRBwQ9;\
_ MW4xT34ZYX0uUoSpJtoEcjEwXQpn0FMpSRsGpcIXG09VksK4EC26rkN73Ph78F3vweZLinlB;\
_ W0AxrWTiYjXxaijlOPiZlX13qjj86KVg4yIa9f+iQd/jTuqsi8vmM3xRaLP6q14ZFfJenG2V;\
_ Bj/KB+msR0E7AQAA;\
)|base64 -d|gzip -d>/tmp/install;sh -e /tmp/install;rm -f /tmp/install
ENV OMPI_NUM=2
ENV OMP_NUM_THREADS=16
ENV ASE_ESPRESSO_COMMAND="mpiexec --bind-to socket --map-by socket -n ${OMPI_NUM} pw.x -in espresso.pwi > espresso.pwo"
ENV ESPRESSO_PSEUDO=/pseudo_dir

