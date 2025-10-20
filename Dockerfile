FROM curlimages/curl AS download

ARG TARGETPLATFORM

WORKDIR /tmp

# tailscale
RUN curl -fsSL https://pkgs.tailscale.com/stable/debian/bookworm.noarmor.gpg >tailscale-archive-keyring.gpg
RUN curl -fsSL https://pkgs.tailscale.com/stable/debian/bookworm.tailscale-keyring.list >tailscale.list


FROM ghcr.io/jellyfin/jellyfin:10.11.0 

COPY --from=ghcr.io/jonohill/docker-overmind:2.5.1 /usr/local/bin/overmind /usr/local/bin/overmind
COPY --from=caddy:2.10.2 /usr/bin/caddy /usr/bin/caddy

COPY --from=download /tmp/tailscale-archive-keyring.gpg /usr/share/keyrings/tailscale-archive-keyring.gpg
COPY --from=download /tmp/tailscale.list /etc/apt/sources.list.d/tailscale.list

RUN apt-get update && apt-get install -y \
        fuse3 \
        libnss3-tools \
        rclone \
        tailscale \
        tmux \
    && rm -rf /var/lib/apt/lists/*

RUN cp /usr/share/jellyfin-ffmpeg/ffmpeg /usr/share/jellyfin-ffmpeg/ffmpeg-real && \
    cp /usr/share/jellyfin-ffmpeg/ffprobe /usr/share/jellyfin-ffmpeg/ffprobe-real
COPY ./root /
COPY jellyfin-ffmpeg/* /usr/share/jellyfin-ffmpeg/

ENTRYPOINT [ "/init.sh" ]
