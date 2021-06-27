# Building the main process inside Docker container

This source code was created for a Hungarian [Youtube tutorial](https://youtu.be/KWyNaEUw3W8)It demonstrates who you can build the main process (the first process with 1 as PID) inside a Docker container using SHELL, ENTRYPOINT and CMD.

Each Dockerfile has a version number. You can run the tests using [test.sh](test.sh) and passing the version as an argument:

```bash
./test.sh v1
./test.sh v2
```

Pass as command optionally as the secnd argument

```bash
./test.sh v1 'echo "Hello Docker"'
```

Run all tests using [test-all.sh](test-all.sh)

```bash
./test-all.sh
```

Or delete everything with [reset.sh](reset.sh)

```bash
./reset.sh
```

**NOTE**: This script will delete container with a name starting with "command-v" and images which have names starting with "localhost/command:". Make sure you don't have any image or container that you don't want to delete.