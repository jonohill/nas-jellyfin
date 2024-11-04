#!/usr/bin/env bash

# try a few times
for i in {1..5}; do
    if tailscale up --authkey "$TS_AUTHKEY" --hostname "$TS_HOSTNAME"; then
        break
    fi
    
    if [ "$i" -eq 5 ]; then
        echo "Failed to connect to Tailscale"
        exit 1
    fi

    sleep 1
done

exec tailscale serve --yes 8096
