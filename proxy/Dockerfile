#syntax=docker/dockerfile:1-labs
ARG RUST_VERSION=1.71.0
ARG ALPINE_VERSION=3.18

####################################################################################################
## Builder
####################################################################################################
FROM rust:${RUST_VERSION}-alpine${ALPINE_VERSION} AS builder

RUN rustup set profile minimal && \ 
    apk add --no-cache \
    build-base

ADD --keep-git-dir=true https://github.com/TeamPiped/piped-proxy.git /piped-proxy

WORKDIR /piped-proxy

RUN mkdir src && \ 
    echo "fn main() {}" > src/main.rs
COPY piped-proxy/Cargo.* ./
RUN cargo build --release && \
    rm -rf src

COPY piped-proxy ./
RUN touch src/main.rs && \
    cargo build --release

####################################################################################################
### Final image
####################################################################################################
FROM alpine:${ALPINE_VERSION}

COPY --from=builder --chmod=0755 /piped-proxy/target/release/piped-proxy /usr/local/bin/piped-proxy

RUN adduser --disabled-password --gecos "" --no-create-home piped

USER piped

CMD ["piped-proxy"]

EXPOSE 8080

STOPSIGNAL SIGTERM

LABEL org.opencontainers.image.source="https://github.com/TheSilkky/piped-docker.git"
LABEL org.opencontainers.image.title="Piped Proxy"
LABEL org.opencontainers.image.description="A proxy for Piped written in Rust"
LABEL org.opencontainers.image.licenses="AGPL-3.0-or-later"