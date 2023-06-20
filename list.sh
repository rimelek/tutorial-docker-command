#!/usr/bin/env bash

source ./resources.sh

echo "$(
  echo -e "\e[37mContainer\e[0m||\e[37mCommand\e[0m||\e[37mOutput\e[0m"
  for container in $(docker container ls -a --format '{{ .Names }}' --filter 'name=command-v*' | sort -V); do
    container_inspect "$container"
  done
)" | column -t -s "||"