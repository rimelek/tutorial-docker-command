#!/usr/bin/env bash

source ./resources.sh

containers="$(docker container ls -a -q --filter="name=command-v*")"
[[ -n "$containers" ]] && docker container rm $containers

images="$(docker image ls "$image:*" -q | uniq)"
[[ -n "$images" ]] && docker image rm -f $images