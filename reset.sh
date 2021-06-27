#!/bin/bash
image="localhost/command"

containers="$(docker container ls -a -q --filter="name=command-v*")"
[[ -n "$containers" ]] && docker container rm $containers

images="$(docker image ls "$image:*" -q | uniq)"
[[ -n "$images" ]] && docker image rm -f $images