# Building the main process inside Docker container

This source code was created for a Hungarian [Youtube tutorial](https://youtu.be/KWyNaEUw3W8)
It demonstrates how you can build the main process (the first process with 1 as PID) inside a Docker container using SHELL, ENTRYPOINT and CMD.

Each Dockerfile has a version number. You can run the tests using [test.sh](test.sh) and passing the version as an argument:

```bash
./test.sh v1
./test.sh v2
```

Pass as command optionally as the second argument

```bash
./test.sh v1 'echo "Hello Docker"'
```

Run all tests using [test-all.sh](test-all.sh)

```bash
./test-all.sh
```

You can also list the already created containers:

```bash
./list.sh
```

Or delete everything with [reset.sh](reset.sh)

```bash
./reset.sh
```

**NOTE**: This script will deletes containers and images created by the tests. It uses open container annotations to identify whether the container was created by this project and will fail if the required label is not found or the repository stored as image source is different. If you had an existing container with the same name (not likely), you can export an environment variable in your terminal to override the default container prefix which is "command":

```bash
export CONTAINER_NAME_PREFIX=mycommand
```
