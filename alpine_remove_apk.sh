#!/bin/sh

docker_remove_apk() {
    # Might as well upgrade everything
    apk upgrade

    # Remove apk
    apk del --repositories-file /dev/null apk-tools alpine-keys libc-utils

    # Delete apk installation data
    rm -rf /var/cache/apk /lib/apk /etc/apk
}

docker_remove_apk

dockerfile() {
################################################################################
# Uninstall apk from alpine linux.

FROM alpine
RUN
FROM scratch
COPY --from=0 / /
CMD ["/bin/sh"]

#   All:
#   -> 6,397,952
#
#   Bare; no apk no SSL:  apk del apk-tools alpine-keys libc-utils
#   -> 1,990,656
#
#       busybox-1.31.1-r9 description:
#       Size optimized toolbox of many common UNIX utilities
#       962560
#
#       alpine-baselayout-3.2.0-r3 description:
#       Alpine base dir structure and init scripts
#       413696
#
#       musl-1.1.24-r2 description:
#       the musl c library (libc) implementation
#       614400
#
#   Size of apk only.
#   -> 720,896
#
#       alpine-keys-2.1-r2 description:
#       Public keys for Alpine Linux packages
#       98304
#
#       apk-tools-2.10.5-r0 description:
#       Alpine Package Keeper - package manager for alpine
#       262144
#
#       musl-utils-1.1.24-r2 description:
#       the musl c library (libc) implementation
#       151552
#
#       libc-utils-0.7.2-r0 description:
#       Meta package to pull in correct libc
#       4096
#
#       zlib-1.2.11-r3 description:
#       A compression/decompression Library
#       110592
#
#       scanelf-1.2.4-r0 description:
#       Scan ELF binaries for stuff
#       94208
#
#   Size of SSL
#   -> 3,686,400
#
#       libcrypto1.1-1.1.1g-r0 description:
#       Crypto library from openssl
#       2760704
#
#       libssl1.1-1.1.1g-r0 description:
#       SSL shared libraries
#       540672
#
#       ca-certificates-cacert-20191127-r1 description:
#       Mozilla bundled certificates
#       245760
#
#       libtls-standalone-2.9.1-r0 description:
#       libtls extricated from libressl sources
#       110592
#
#       ssl_client-1.31.1-r9 description:
#       EXternal ssl_client for busybox wget
#       28672
}
