#!/bin/sh
dockerfile() {
FROM rdebath/ubuntu:wily
ARG RUBY_VERSION=2.3
}

apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C3173AA6
echo deb http://ppa.launchpad.net/brightbox/ruby-ng/ubuntu wily main \
    > /etc/apt/sources.list.d/brightbox-ruby-ng-trusty.list

apt-get update -q
apt-get install -yq \
    --no-install-recommends \
    build-essential autoconf bison libreadline6-dev \
    zlib1g-dev libncurses5-dev libssl-dev libyaml-dev \
    \
    ruby"$RUBY_VERSION" \
    ruby"$RUBY_VERSION"-dev

apt-get clean
mkdir /tmp/empty
apt-get update -qq --list-cleanup \
    -oDir::Etc::SourceList=/dev/null \
    -oDir::Etc::SourceParts=/tmp/empty
rmdir /tmp/empty

:|find /var/log -type f -exec tee {} \;

gem update --system && gem install bundler --no-document
