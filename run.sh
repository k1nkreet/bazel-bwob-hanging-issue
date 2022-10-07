#!/bin/sh

wait_grpc_ready() {
    while ! grpcurl -plaintext $1:$2 grpc.health.v1.Health/Check; do
        sleep 1
    done
}

BAZEL="${BAZEL:-bazelisk}"

BWOB_FLAGS="--remote_download_toplevel"
REMOTE_FLAGS="--remote_executor=grpc://localhost:8980" 

echo "setup buildbarn"
(cd buildbarn; ./run.sh --detach)
wait_grpc_ready localhost 8980 || exit 1
echo

echo "initial build"
echo "a1" > a.in
echo "b1" > b.in
$BAZEL clean
$BAZEL build :b $REMOTE_FLAGS
echo

echo "standard rebuild"
$BAZEL clean
$BAZEL build :b $BWOB_FLAGS $REMOTE_FLAGS
echo

sudo find buildbarn/worker-ubuntu22-04/cache -type f -delete
sudo rm -rf buildbarn/storage-cas-0/blocks
docker-compose -f buildbarn/docker-compose.yml stop
(cd buildbarn; ./run.sh --detach)

wait_grpc_ready localhost 8980 || exit 1

echo b2 > b.in

echo "rebuild with CAS cleared"
$BAZEL build :b $BWOB_FLAGS $REMOTE_FLAGS
echo

docker-compose -f buildbarn/docker-compose.yml down
