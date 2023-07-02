#!/usr/bin/env bash

set -eu -o pipefail

cd "$(dirname "$0")"

source ./resources.sh

# Run tests with and without arguments

index=0

while (( index < ${#TESTS[@]} )); do
  version="${TESTS[$index]}"; (( ++index ))
  arg="${TESTS[$index]}";     (( ++index ))

  err=0
  ./build.sh $version || err=$?
  echo
  if (( $err == 0 )); then
    ./run.sh $version || true
    echo
    ./run.sh $version "$arg" || true
    echo
  fi
done

./list.sh
