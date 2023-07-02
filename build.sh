#!/usr/bin/env bash

set -eu -o pipefail

version="$1"

source ./resources.sh

tag="$IMAGE_REF_NAME:$version"

run "docker build . --force-rm -f Dockerfile.$version -t $tag \\
  --build-arg \"SOURCE=$IMAGE_SOURCE\" \\
  --build-arg \"REF_NAME=$IMAGE_REF_NAME\" \\
  --build-arg \"VERSION=$version\""
