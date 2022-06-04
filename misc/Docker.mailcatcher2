FROM ruby:2.3-alpine

LABEL \
    maintainer="Morgan AUCHEDE <morgan.auchede@gmail.com>"

RUN set -e -u -x \
\
    # Install packages
\
    && apk add --no-cache --no-progress --virtual BUILD_DEPS build-base curl gmp-dev sqlite-dev \
    && apk add --no-cache --no-progress bash ca-certificates gmp libstdc++ sqlite-libs tzdata \
\
    # Install mailcatcher
\
    && gem install --no-verbose mailcatcher \
\
    # Clean
\
    && apk del --no-progress BUILD_DEPS \
    && rm -f -r /root/.gem /tmp/*
