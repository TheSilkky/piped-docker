ARG RUST_VERSION=1.65.0
ARG ALPINE_VERSION=3.16

####################################################################################################
## Builder
####################################################################################################
FROM rust:${RUST_VERSION}-alpine${ALPINE_VERSION} AS builder

RUN apk add --no-cache \
    ca-certificates \
    build-base \
    git

ADD https://git.silkky.dev/api/v1/repos/github/piped-proxy/git/refs/head /cachebreak
RUN git clone https://git.silkky.dev/github/piped-proxy.git /piped-proxy

WORKDIR /piped-proxy

RUN cargo build --release

####################################################################################################
### Final image
####################################################################################################
FROM alpine:${ALPINE_VERSION}

RUN apk add --no-cache \
    ca-certificates \
    tini

WORKDIR /piped-proxy

COPY --from=builder /piped-proxy/target/release/piped-proxy /piped-proxy/piped-proxy

RUN adduser --disabled-password --gecos "" --no-create-home piped \
    && chown -R piped:piped /piped-proxy

USER piped

ENTRYPOINT ["/sbin/tini", "--"]

CMD ["/piped-proxy/piped-proxy"]

EXPOSE 8080

STOPSIGNAL SIGTERM

LABEL org.opencontainers.image.title="Piped Proxy"
LABEL org.opencontainers.image.description="An alternative privacy-friendly YouTube frontend which is efficient by design."
LABEL org.opencontainers.image.licenses="AGPL-3.0-or-later"
LABEL org.opencontainers.image.source="https://git.silkky.dev/ellie/piped-docker.git"