#!/bin/sh

dockerfile() {
# This Dockerfile is able to use a plain debootstrap install to install
# a debian based release directly supported by the current release of
# debootstrap.
#
# Worked with jessie, stretch, buster, bullseye and sid
#
FROM alpine AS unpack
RUN apk add --no-cache debootstrap perl
ARG RELEASE=stable
ARG ARCH=amd64
RUN debootstrap --foreign --arch="$ARCH" --components=main,contrib,non-free \
    --variant=minbase "$RELEASE" /opt/chroot
FROM scratch AS stage2
COPY --from=unpack /opt/chroot /
RUN /debootstrap/debootstrap --second-stage
RUN
FROM scratch AS squashed
COPY --from=stage2 / /
WORKDIR /root
CMD [ "bash" ]
}

main() {
    echo > /usr/sbin/policy-rc.d-docker \
'#!/bin/sh
exit 101'

    update-alternatives --install /usr/sbin/policy-rc.d policy-rc.d \
            /usr/sbin/policy-rc.d-docker 50

    if [ -x /usr/bin/ischroot ]
    then dpkg-divert --local --rename --add /usr/bin/ischroot 2>/dev/null &&
	 ln -s /bin/true /usr/bin/ischroot
    fi

    : "Clean lists, cache and history."
    apt-get update -qq --list-cleanup -oDir::Etc::SourceList=/dev/null
    apt-get clean
    dpkg --clear-avail
    rm -f /etc/apt/apt.conf.d/01autoremove-kernels
    rm -f /var/lib/dpkg/*-old
    rm -rf /var/tmp/* /tmp/*
    :|find /var/log -type f ! -exec tee {} \;

    [ -e /etc/debian_chroot ] || echo docker > /etc/debian_chroot

    echo > '/etc/dpkg/dpkg.cfg.d/docker-unsafe' force-unsafe-io

    D=/etc/apt/apt.conf.d/docker
    echo > $D-language 'Acquire::Languages "none";'
    echo > $D-nosuggest 'Apt::AutoRemove::SuggestsImportant "false";'
    echo > $D-gzipind 'Acquire::GzipIndexes "true";'

    echo > $D-cleanup \
'// This attempts to clean the cache automatically, though rather ugly it does
// work unlike the better looking alternatives.
// See: https://github.com/debuerreotype/debuerreotype/issues
DPkg::Post-Invoke { "rm -f /var/cache/apt/archives/*.deb /var/cache/apt/archives/partial/*.deb /var/cache/apt/*.bin || true"; };
APT::Update::Post-Invoke { "rm -f /var/cache/apt/archives/*.deb /var/cache/apt/archives/partial/*.deb /var/cache/apt/*.bin || true"; };

Dir::Cache::pkgcache "";
Dir::Cache::srcpkgcache "";
'

}

main "$@"

