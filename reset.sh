#!/usr/bin/env bash

source ./resources.sh

filter=(
  --filter
  "label=org.opencontainers.image.source=$IMAGE_SOURCE"
)

containers="$(docker container ls -a -q "${filter[@]}")"

echo "Removing containers..."
if [[ -n "$containers" ]]; then
  docker container rm $containers
else
  echo "There were no containers to remove"
fi
echo

images="$(docker image ls -q "${filter[@]}" | uniq)"

echo "Removing images..."
if [[ -n "$images" ]]; then
  docker image rm -f $images
else
  echo "There were no images to remove"
fi