#syntax=docker/dockerfile:1-labs

ARG RUST_VERSION=1.71.0
ARG ALPINE_VERSION=3.18

####################################################################################################
## Get source code
####################################################################################################
FROM scratch AS source

ADD --keep-git-dir=true https://github.com/TeamPiped/piped-proxy.git /piped-proxy

####################################################################################################
## AMD64 builder
####################################################################################################
FROM --platform=${BUILDPLATFORM} blackdex/rust-musl:x86_64-musl-stable-${RUST_VERSION} AS build-amd64

ENV DEBIAN_FRONTEND=noninteractive
ENV CARGO_HOME="/root/.cargo"

RUN mkdir -pv "${CARGO_HOME}" && \
    rustup set profile minimal && \
    rustup target add x86_64-unknown-linux-musl

WORKDIR /piped-proxy

RUN mkdir src && \ 
    echo "fn main() {}" > src/main.rs
COPY --from=source /piped-proxy/Cargo.* ./
RUN cargo build --target=x86_64-unknown-linux-musl --release && \
    rm -rf src

COPY --from=source /piped-proxy ./
RUN touch src/main.rs && \
    cargo build --target=x86_64-unknown-linux-musl --release && \
    mv target/x86_64-unknown-linux-musl/release/piped-proxy .

####################################################################################################
## ARM64 builder
####################################################################################################
FROM --platform=${BUILDPLATFORM} blackdex/rust-musl:aarch64-musl-stable-${RUST_VERSION} AS build-arm64

ENV DEBIAN_FRONTEND=noninteractive
ENV CARGO_HOME="/root/.cargo"

RUN mkdir -pv "${CARGO_HOME}" && \
    rustup set profile minimal && \
    rustup target add aarch64-unknown-linux-musl

WORKDIR /piped-proxy

RUN mkdir src && \ 
    echo "fn main() {}" > src/main.rs
COPY --from=source /piped-proxy/Cargo.* ./
RUN cargo build --target=aarch64-unknown-linux-musl --release && \
    rm -rf src

COPY --from=source /piped-proxy ./
RUN touch src/main.rs && \
    cargo build --target=aarch64-unknown-linux-musl --release && \
    mv target/aarch64-unknown-linux-musl/release/piped-proxy .

####################################################################################################
## Get target binary
####################################################################################################
FROM build-${TARGETARCH} AS build

####################################################################################################
### Final image
####################################################################################################
FROM alpine:${ALPINE_VERSION}

ARG UID=911
ARG GID=911

COPY --from=build --chmod=0755 /piped-proxy/piped-proxy /usr/local/bin/piped-proxy

RUN addgroup -S -g ${GID} piped && \
    adduser -S -H -D -G traefik -u ${UID} -s /sbin/nologin piped

USER piped

CMD ["piped-proxy"]

EXPOSE 8080

STOPSIGNAL SIGTERM

LABEL org.opencontainers.image.source="https://github.com/TeamPiped/piped-proxy.git"
LABEL org.opencontainers.image.title="Piped Proxy"
LABEL org.opencontainers.image.description="A proxy for Piped written in Rust"
LABEL org.opencontainers.image.licenses="AGPL-3.0-or-later"