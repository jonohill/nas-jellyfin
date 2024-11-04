#!/bin/bash

set -e

docker build -t jellyfin .

mkdir test || true

docker run -ti --rm \
    -v "$(pwd)/test:/config" \
    -e RCLONE_MOUNT_DIR \
    -e TS_AUTHKEY \
    -e TS_HOSTNAME="jellyfin" \
    --cap-add SYS_ADMIN \
    --device /dev/fuse \
    jellyfin
