#!/bin/bash

# https://success.docker.com/article/how-do-i-authenticate-with-the-v2-api

# jq -r '[.results|.[]|{updated:.last_updated,repo:"ubuntu",tag: .name}]|.[]|join("\t")' < Repo.ubuntu.tags.json | sort

set -e

# set username and password
UPASS=$(jq < ~/.docker/config.json ".auths.\"https://index.docker.io/v1/\".auth" | base64 -di)
UNAME="${UPASS%%:*}"
UPASS="${UPASS#*:}"

# get token to be able to talk to Docker Hub
TOKEN=$(curl -s -H "Content-Type: application/json" -X POST \
    -d '{"username": "'"${UNAME}"'", "password": "'"${UPASS}"'"}' \
    https://hub.docker.com/v2/users/login/ | jq -r .token)

# get list of repos for that user account
REPO_LIST=$(curl -s -H "Authorization: JWT ${TOKEN}" \
    "https://hub.docker.com/v2/repositories/${UNAME}/?page_size=10000" |
    jq -r '.results|.[]|.name')

# build a list of all images & tags
for i in ${REPO_LIST}
do
  # get tags for repo
  IMAGE_TAGS=$(curl -s -H "Authorization: JWT ${TOKEN}" \
    "https://hub.docker.com/v2/repositories/${UNAME}/${i}/tags/?page_size=10000" |
	tee "Repo.$i.tags.json" | jq -r '.results|.[]|.name')

  # build a list of images from tags
  for j in ${IMAGE_TAGS}
  do
    # add each tag to list
    FULL_IMAGE_LIST="${FULL_IMAGE_LIST} ${UNAME}/${i}:${j}"
  done
done

# output list of all docker images
for i in ${FULL_IMAGE_LIST}
do
  echo "${i}"
done
