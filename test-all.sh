#!/usr/bin/env bash

./test.sh v1
./test.sh v2
./test.sh v3
./test.sh v4
./test.sh v5
./test.sh v6
./test.sh v7
./test.sh v8
./test.sh v9
./test.sh v10
./test.sh v11


./test.sh v1 'echo "Hello Docker"'
./test.sh v2 'echo "Hello Docker"'
./test.sh v3 'echo "Hello Docker"'
./test.sh v4 '/hello.sh'
./test.sh v5 '/hello.sh'
./test.sh v6 'my friend'
./test.sh v7 'my friend'
./test.sh v8 'my friend'
./test.sh v9 'my friend'
./test.sh v10 'my friend'
./test.sh v11 'my friend'