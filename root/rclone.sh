#!/usr/bin/env bash

mkdir -p /media/rclone || true

exec rclone mount -v \
    --config /config/rclone/rclone.conf \
    --vfs-cache-mode full \
    --cache-dir /cache/rclone \
    "${RCLONE_MOUNT_DIR}" \
    /media/rclone
