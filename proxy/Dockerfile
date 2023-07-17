#syntax=docker/dockerfile:1-labs

ARG RUST_VERSION=1.71.0
ARG ALPINE_VERSION=3.18

####################################################################################################
## Get source code
####################################################################################################
FROM scratch AS source

ADD --keep-git-dir=true https://github.com/TeamPiped/piped-proxy.git /piped-proxy

####################################################################################################
## AMD64 builder base
####################################################################################################
FROM --platform=${BUILDPLATFORM} blackdex/rust-musl:x86_64-musl-stable-${RUST_VERSION} AS base-amd64

ENV DEBIAN_FRONTEND=noninteractive
ENV CARGO_HOME="/root/.cargo"

RUN mkdir -pv "${CARGO_HOME}" && \
    rustup set profile minimal && \
    rustup target add x86_64-unknown-linux-musl

RUN cargo install cargo-chef

####################################################################################################
## ARM64 builder base
####################################################################################################
FROM --platform=${BUILDPLATFORM} blackdex/rust-musl:aarch64-musl-stable-${RUST_VERSION} AS base-arm64

ENV DEBIAN_FRONTEND=noninteractive
ENV CARGO_HOME="/root/.cargo"

RUN mkdir -pv "${CARGO_HOME}" && \
    rustup set profile minimal && \
    rustup target add aarch64-unknown-linux-musl

RUN cargo install cargo-chef

####################################################################################################
## Generate cargo-chef recipe
####################################################################################################
FROM base-amd64 AS chef-prepare

WORKDIR /piped-proxy

COPY --from=source /piped-proxy ./

RUN cargo chef prepare --recipe-path recipe.json

####################################################################################################
## AMD64 builder
####################################################################################################
FROM base-amd64 AS build-amd64

WORKDIR /piped-proxy

COPY --from=chef-prepare /piped-proxy/recipe.json ./
RUN cargo chef cook --target=x86_64-unknown-linux-musl --release --recipe-path recipe.json

COPY --from=source /piped-proxy ./
RUN cargo build --target=x86_64-unknown-linux-musl --release && \
    mv target/x86_64-unknown-linux-musl/release/piped-proxy .

####################################################################################################
## ARM64 builder
####################################################################################################
FROM base-arm64 AS build-arm64

WORKDIR /piped-proxy

COPY --from=chef-prepare /piped-proxy/recipe.json ./
RUN cargo chef cook --target=aarch64-unknown-linux-musl --release --recipe-path recipe.json

COPY --from=source /piped-proxy ./
RUN cargo build --target=aarch64-unknown-linux-musl --release && \
    mv target/aarch64-unknown-linux-musl/release/piped-proxy .

####################################################################################################
## Get target binary
####################################################################################################
FROM build-${TARGETARCH} AS build

####################################################################################################
### Final image
####################################################################################################
FROM alpine:${ALPINE_VERSION}

COPY --from=build --chmod=0755 /piped-proxy/piped-proxy /usr/local/bin/piped-proxy

RUN adduser --disabled-password --gecos "" --no-create-home piped

USER piped

CMD ["piped-proxy"]

EXPOSE 8080

STOPSIGNAL SIGTERM

LABEL org.opencontainers.image.source="https://github.com/TheSilkky/piped-docker.git"
LABEL org.opencontainers.image.title="Piped Proxy"
LABEL org.opencontainers.image.description="A proxy for Piped written in Rust"
LABEL org.opencontainers.image.licenses="AGPL-3.0-or-later"