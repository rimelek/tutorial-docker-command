#!/usr/bin/env bash

source ./resources.sh

echo "$(
  echo -e "\e[37mContainer\e[0m||\e[37mCommand\e[0m||\e[37mOutput\e[0m"
  while (( index < ${#TESTS[@]} )); do
    version="${TESTS[$index]}"; (( ++index ))
    arg="${TESTS[$index]}";     (( ++index ))

    container="$CONTAINER_NAME_PREFIX-$version-0"
    filter=(
      --filter "label=org.opencontainers.image.source=$IMAGE_SOURCE"
      --filter "name=^$container\$"
    )

    container_inspect "$container"
  done
)" | column -t -s "||"