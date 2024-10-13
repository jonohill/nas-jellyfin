#!/usr/bin/env bash

if [ "$1" = "--version" ]; then
    /jellyfin/jellyfin --version | grep -oE '[0-9]+\.[0-9]+\.[0-9]+'
    exit 0
fi

exec overmind start "$@"
