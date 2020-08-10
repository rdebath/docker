
: Dockerfile <<@
FROM alpine AS quark
@@

FROM alpine AS eleventy
RUN apk --no-cache add npm
RUN npm install -g @11ty/eleventy

WORKDIR /var/www
WORKDIR /root/app
COPY . .
RUN eleventy --input=. --output=/var/www

FROM scratch
COPY --from=quark / /
WORKDIR /var/www
COPY --from=eleventy /var/www .
EXPOSE 80
CMD quark -h 0.0.0.0 -p 80 -l
@

A=git://git.suckless.org/quark; B=/opt/quark
apk --no-cache add -t build-packages git make gcc libc-dev
git clone "$A" "$B"
make -C "$B" install
rm -rf "$B"
apk del --repositories-file /dev/null build-packages

# Remove apk
apk del --repositories-file /dev/null apk-tools alpine-keys libc-utils
rm -rf /var/cache/apk /lib/apk /etc/apk
