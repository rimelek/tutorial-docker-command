#!/usr/bin/env bash

source ./resources.sh

echo "$(
  echo -e "\e[37mContainer\e[0m||\e[37mCommand\e[0m||\e[37mOutput\e[0m"
  while (( index < ${#TESTS[@]} )); do
    version="${TESTS[$index]}"; (( ++index ))

    container_inspect "$CONTAINER_NAME_PREFIX-$version-0"
    container_inspect "$CONTAINER_NAME_PREFIX-$version-1"
  done
)" | column -t -s "||"