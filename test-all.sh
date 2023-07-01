#!/usr/bin/env bash

args=(
  v1  'echo "Hello Docker"'
  v2  'echo "Hello Docker"'
  v3  'echo "Hello Docker"'
  v4  '/hello.sh'
  v5  '/hello.sh'
  v6  'my friend'
  v7  'my friend'
  v8  'my friend'
  v9  'my friend'
  v10 'my friend'
  v11 'my friend'
)

cd "$(dirname "$0")"

# Run tests with and without arguments

index=0

while (( index < ${#args[@]} )); do
  version="${args[$index]}"; (( ++index ))
  arg="${args[$index]}";     (( ++index ))
  SKIP_BUILD=0 ./test.sh $version
  SKIP_BUILD=1 ./test.sh $version "$arg"
done