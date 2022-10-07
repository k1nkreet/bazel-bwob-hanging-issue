This repo demonstrates the issue appeared in Bazel 5.3

Before that Bazel was raising FileNotFoundException in case of outputs evicted from CAS
in remote exectuted build without bytes (https://github.com/bazelbuild/bazel/issues/8250)

Starting from 5.3 instead of failing with FileNotFoundException Bazel just hangs infinitely.

# Requirements

Script reproducing the issue requires `bazelisk` and `grpcurl` installed

`shell.nix` is included in this repo, so Nix-users can just invoke `nix-shell` and run test scenario
inside it.

# Run

To observe it one could run

```
USE_BAZEL_VERSION=5.3.1 ./run.sh
```

or

```
USE_BAZEL_VERSION=5.2.0 ./run.sh
```

or one can use custom Bazel binary against this scenario:

```
BAZEL=/path/to/bazel/binary ./run.sh
```
