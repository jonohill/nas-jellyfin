FROM curlimages/curl AS download

ARG TARGETPLATFORM

ARG OVERMIND_VERSION=2.5.1

WORKDIR /tmp

# overmind
RUN ARCH="${TARGETPLATFORM#*/}"; \
    curl --fail -L -o /tmp/overmind.gz \
        https://github.com/DarthSim/overmind/releases/download/v${OVERMIND_VERSION}/overmind-v${OVERMIND_VERSION}-linux-${ARCH}.gz && \
    gunzip /tmp/overmind.gz && \
    chmod +x /tmp/overmind

# tailscale
RUN curl -fsSL https://pkgs.tailscale.com/stable/debian/bookworm.noarmor.gpg >tailscale-archive-keyring.gpg
RUN curl -fsSL https://pkgs.tailscale.com/stable/debian/bookworm.tailscale-keyring.list >tailscale.list


FROM ghcr.io/jellyfin/jellyfin:10.10.1 

COPY --from=download /tmp/overmind /usr/local/bin/overmind

COPY --from=download /tmp/tailscale-archive-keyring.gpg /usr/share/keyrings/tailscale-archive-keyring.gpg
COPY --from=download /tmp/tailscale.list /etc/apt/sources.list.d/tailscale.list

RUN apt-get update && apt-get install -y \
        caddy \
        fuse3 \
        libnss3-tools \
        rclone \
        tailscale \
        tmux \
    && rm -rf /var/lib/apt/lists/*

COPY ./root /

ENTRYPOINT [ "/init.sh" ]
