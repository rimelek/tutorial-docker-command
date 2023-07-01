#!/usr/bin/env bash

set -eu -o pipefail

version="$1"
args="${2:-}"

source ./resources.sh

stderr_tmp=$(mktemp)
stdout_tmp=$(mktemp)

tag="localhost/$REPO_OWNER/$REPO_NAME:$version"
container="$CONTAINER_NAME_PREFIX-$version-$([[ -n "$args" ]] && echo "1" || echo "0")"

run "docker build . --force-rm -f Dockerfile.$version -t $tag \\
  --build-arg \"SOURCE=$IMAGE_SOURCE\" \\
  --build-arg \"REF_NAME=$IMAGE_REF_NAME\" \\
  --build-arg \"VERSION=$version\"" || true
echo

if [[ -n "$(docker container ls -q -a --filter="name=^$container\$")" ]]; then
  if [[ "$IMAGE_SOURCE" == "$(docker container inspect "$container" --format '{{ index .Config.Labels "org.opencontainers.image.source" }}')" ]]; then
    runq "docker container rm -f \"$container\""
  else
    >&2 echo "The container \"$container\" cannot be deleted safely because the following label cannot be found or the value is different: "
    >&2 echo "LABEL: org.opencontainers.image.source=$IMAGE_SOURCE"
    exit 1
  fi
fi

run "docker run -i --name \"$container\" \"$tag\"" "${args}" || true

echo

./list.sh