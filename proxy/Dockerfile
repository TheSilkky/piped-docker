# syntax=docker/dockerfile:1-labs

ARG RUST_VERSION=1.70.0
ARG ALPINE_VERSION=3.18

####################################################################################################
## Builder
####################################################################################################
FROM rust:${RUST_VERSION}-alpine${ALPINE_VERSION} AS builder

RUN apk add --no-cache \
    ca-certificates \
    tzdata \
    build-base

ADD https://github.com/TeamPiped/piped-proxy.git /piped-proxy

WORKDIR /piped-proxy

RUN cargo build --release

####################################################################################################
### Final image
####################################################################################################
FROM alpine:${ALPINE_VERSION}

RUN apk add --no-cache \ 
    ca-certificates \
    tzdata

COPY --from=builder /piped-proxy/target/release/piped-proxy /usr/local/bin/piped-proxy

RUN adduser --disabled-password --gecos "" --no-create-home piped

USER piped

CMD ["piped-proxy"]

EXPOSE 8080

STOPSIGNAL SIGTERM

LABEL org.opencontainers.image.source="https://github.com/TheSilkky/piped-docker.git"
LABEL org.opencontainers.image.title="Piped Proxy"
LABEL org.opencontainers.image.description="A proxy for Piped written in Rust"
LABEL org.opencontainers.image.licenses="AGPL-3.0-or-later"