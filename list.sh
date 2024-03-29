#!/usr/bin/env bash

source ./resources.sh

echo "$(
  set -eu -o pipefail
  echo -e "\e[37mContainer\e[0m||\e[37mCommand\e[0m||\e[37mOutput\e[0m"
  index=0
  while (( index < ${#TESTS[@]} )); do
    version="${TESTS[$index]}"; (( index+=2 ))

    container_inspect "$CONTAINER_NAME_PREFIX-$version-0"
    container_inspect "$CONTAINER_NAME_PREFIX-$version-1"
  done
)" | column -t -s "||"