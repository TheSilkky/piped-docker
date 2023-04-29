ARG RUST_VERSION=1.67.1
ARG ALPINE_VERSION=3.17
ARG PIPED_PROXY_VERSION=76103eddc231e9c4522b6d65653beb0501131d80

####################################################################################################
## Builder
####################################################################################################
FROM rust:${RUST_VERSION}-alpine${ALPINE_VERSION} AS builder

ARG PIPED_PROXY_VERSION

RUN apk add --no-cache \
    ca-certificates \
    build-base \
    git

WORKDIR /piped-proxy

RUN git init \
    && git remote add origin https://git.silkky.dev/github/piped-proxy.git \
    && git fetch origin ${PIPED_PROXY_VERSION} \
    && git reset --hard FETCH_HEAD

RUN cargo build --release \
    && mv target/release/piped-proxy .

####################################################################################################
### Final image
####################################################################################################
FROM alpine:${ALPINE_VERSION}

RUN apk add --no-cache \
    ca-certificates \
    tini

WORKDIR /piped-proxy

COPY --from=builder /piped-proxy/piped-proxy /piped-proxy/piped-proxy

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