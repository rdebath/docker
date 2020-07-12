#!/bin/sh
# Copy all images on this machine to another.
# This is really, really, slow and needs about THREE times the
# space taken up by the repos.
#
# Pipelining does not help.

set -e
# Beware, there isn't a wildcard that matches everything with a name.
docker image save \
    $(docker images --format "{{.Repository}}:{{.Tag}}" '*:*' ) | \
    pigz > docker_archive.tar.gz

pv docker_archive.tar.gz |
    ssh "$1" \
    'gzip -d | docker image load'
