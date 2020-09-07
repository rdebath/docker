FROM alpine AS build
RUN apk add --no-cache -t build-packages build-base git nasm tini-static
RUN set -eu;_() { echo "$@";};(\
_ H4sIAAAAAAACA1WLMQ4CIRBFe04xvYGJrYWFlnoJYFmY7DIQGBKPL2qzdi//vR9JwO+FA2i9;\
_ hCoJzpBEar8gRpI0nPElY1uCs5Lw1izxOvxmpgS3ksp2m9/7h1EaCY2sDoyTTRkCuv+S0IU4;\
_ 4rN0eXA0Dq7fvcZsumLbM+gC6Ihxn8nG8aB9ymWB0+vPqze5eOIpwwAAAA==;\
)|base64 -d|gzip -d>/tmp/install;sh -e /tmp/install;rm -f /tmp/install
FROM scratch
COPY --from=0 /sbin/tini-static /sbin/tini-static
COPY --from=0 /bin/lostkng /bin/lostkng
ENTRYPOINT ["/sbin/tini-static","--"]
CMD ["lostkng"]
