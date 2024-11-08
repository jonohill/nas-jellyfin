#!/usr/bin/env bash

set -e

for arg in "$@"; do

    if [ "$arg" = "caddy" ]; then
        while ! curl --silent --fail https://id.jottacloud.com:443 >/dev/null; do
            echo "Waiting for caddy..."
            sleep 1
        done
    fi

    if [ "$1" = "rclone" ]; then
        while [ ! "$(ls -A /media/rclone)" ]; do
            echo "Waiting for rclone mount..."
            sleep 1
        done
    fi

done
