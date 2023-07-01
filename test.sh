#!/usr/bin/env bash

set -eu -o pipefail

version="$1"
args="${2:-}"

source ./resources.sh

stderr_tmp=$(mktemp)
stdout_tmp=$(mktemp)

tag="$image:$version"
container="command-$version-$([[ -n "$args" ]] && echo "1" || echo "0")"
run "docker build . --force-rm -f Dockerfile.$version -t $tag" || true
echo

if [[ -n "$(docker container ls -q -a --filter="name=$container")" ]]; then
  runq "docker container rm -f \"$container\""
fi

run "docker run -i --name \"$container\" \"$tag\"" "${args}" || true

echo

./list.sh