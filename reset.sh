#!/usr/bin/env bash

source ./resources.sh

filter=(
  --filter
  "label=org.opencontainers.image.source=$IMAGE_SOURCE"
)

containers="$(docker container ls -a -q "${filter[@]}")"
[[ -n "$containers" ]] && docker container rm $containers

images="$(docker image ls -q "${filter[@]}" | uniq)"
[[ -n "$images" ]] && docker image rm -f $images