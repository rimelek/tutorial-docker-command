#!/usr/bin/env bash

source ./resources.sh

filter=(
  --filter
  "label=org.opencontainers.image.source=$IMAGE_SOURCE"
)

echo "$(
  echo -e "\e[37mContainer\e[0m||\e[37mCommand\e[0m||\e[37mOutput\e[0m"
  for container in $(docker container ls -a --format '{{ .Names }}' "${filter[@]}" | sort -V); do
    container_inspect "$container"
  done
)" | column -t -s "||"