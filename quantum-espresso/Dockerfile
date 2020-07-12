# Dockerfile to build quantum-espresso:latest
#--------------------------------------------------------------------------#
FROM debian as build-base
ENV LANG=C.UTF-8
ENV PATH=/opt/conda/bin:$PATH
WORKDIR /workspace
RUN : Install Debian ;set -e;_() { echo "$@";};(\
_ H4sIAAAAAAACAzXLMQ7AIAgAwFlfwQdY+iOKaEiINYBD+/p26XjDFVqJQxL2apRSy2+dkWQG;\
_ eMO51RpKhMxUMjgfXQcwIYunduUvBvB2g9EvT6cJQ7O+a5jTeFwAAAA=;\
)|base64 -d|gzip -d>/tmp/install;sh -e /tmp/install;rm -f /tmp/install

#--------------------------------------------------------------------------#
FROM build-base AS qedownload
ARG QE_VER=6.5
ARG MPI_VER=4.0
ARG MPI_BLD=4

RUN : Download qe and mpi ;set -e;_() { echo "$@";};(\
_ H4sIAAAAAAACA3WOwQqCQBCGz+5TLOJ1Z6Bjx9AgKMgOXWPdBt1QV9fNIuvdUzQKqjnNfPMz;\
_ 83mkMsP90FzK3MijLlNeEwD4zFNnm/PMuaqZI6ba5TIBZQqMoyXWglCgtCrTLWFNIuji6LCP;\
_ do9hJT4BOGkhuc34nXm8r37k4npizPt+bSoqi0rzHwLHKQZDRvQhMDZFSznJhvAFsQ26zXY1;\
_ mkzXxBvB2C7W4V+tJ6W90xQRAQAA;\
)|base64 -d|gzip -d>/tmp/install;sh -e /tmp/install;rm -f /tmp/install

#--------------------------------------------------------------------------#
FROM build-base AS condabuild
RUN : Download and install miniconda ;set -e;_() { echo "$@";};(\
_ H4sIAAAAAAACA4WQQW7DIBBF1+YUo3RXaaBOU6uqFJ8gXXZXqcKYyEQYkIEq3vTsxTh20kpV;\
_ 2cC8+fP1mULEQQMeoAvB+RfGBuks5YYLa1pOhe1Zr4zKFXtdXo+4o0+0LPGgTDzj+bn6qHbU;\
_ d/BOCkinhnUoUVI0PPVuEWAD6IBZF1hmhBT5BqElN4BBOT+SQqenv5ExGQRzgz0qLWnLVrs/;\
_ eHKVorOwof97bKCu4YvRKesgYJmcU3ER1CcPElJX/lSuyaNrJwWaLAIU0Mojjzp4wBHmX16k;\
_ yvjAtZ74ZWMm9m7cl7Ss6P3CvFCZba/oZButGjIXd+B4cvP7B7rdZQ0pnHJX9zeYggyR91LT;\
_ kff615LVCIhJSb4B13EsAgYCAAA=;\
)|base64 -d|gzip -d>/tmp/install;sh -e /tmp/install;rm -f /tmp/install

#--------------------------------------------------------------------------#
FROM qedownload AS qebuild

ARG VARIANT=latest

RUN : Install openmpi ;set -e;_() { echo "$@";};(\
_ H4sIAAAAAAACAz2OMQ/CIBCFZ/gVJzEdTMDFtUPHLg7GuKgDoVBO4WgU49+Xhtbb3ntfvhyD;\
_ cujgCmJ76U59dzwL2LSQJktxgjtnM5C9Jc6YNT6B6OmddQgLgqCUEtA0cCuEGdZa7kpUe5PI;\
_ 4fh5WZDyi9lLE3VLqWxRP0v5gMNfjFWMNM7KFVnaEsNQbfUnh/wHT3N+Ar0AAAA=;\
)|base64 -d|gzip -d>/tmp/install;sh -e /tmp/install;rm -f /tmp/install
RUN : Install qe ;set -e;_() { echo "$@";};(\
_ H4sIAAAAAAACA4XOOw+CMBAA4Ln9FZeGRZLi4kYY0ChhwQQfq6nlxGopL4l/38rDRBdvudwj;\
_ 3x2RokVgzjFM4zDZM1CGkrJCU1QwA1htk00cHdL1KUyjXcA4RyPOGvm48qkr0QitUQemZOD7;\
_ k6Es8mP0U/eN9/HnwoBhKyS1SV5LYMtO6UyZHGr0PI9RIjOoOfIauUuJN5eluai8axCcb5yS;\
_ QtwR+A0WUD3tu5OoTPuwpTUHsF8bm/QFL5CPESIBAAA=;\
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

