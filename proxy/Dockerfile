ARG GO_VERSION=1.18.6
ARG ALPINE_VERSION=3.16

####################################################################################################
## Builder
####################################################################################################
FROM golang:${GO_VERSION}-alpine${ALPINE_VERSION} AS builder

RUN apk add --no-cache \
    ca-certificates \
    git \
    build-base \
    libwebp-dev

ADD https://api.github.com/repos/TeamPiped/http3-ytproxy/git/refs/head /cachebreak
RUN git clone https://github.com/TeamPiped/http3-ytproxy.git /piped-proxy

WORKDIR /piped-proxy

RUN go build -ldflags "-s -w" main.go

####################################################################################################
### Final image
####################################################################################################
FROM alpine:${ALPINE_VERSION}

RUN apk add --no-cache \
    ca-certificates \
    tini \
    libwebp

WORKDIR /piped-proxy

COPY --from=builder /piped-proxy/main /piped-proxy/http3-ytproxy

RUN adduser --disabled-password --gecos "" --no-create-home piped \
    && chown -R piped:piped /piped-proxy

USER piped

ENTRYPOINT ["/sbin/tini", "--"]

CMD ["/piped-proxy/http3-ytproxy"]

EXPOSE 8080

STOPSIGNAL SIGTERM

LABEL org.opencontainers.image.title="Piped Proxy" \
      org.opencontainers.image.description="An alternative privacy-friendly YouTube frontend which is efficient by design. " \
      org.opencontainers.image.licenses="AGPL-3.0-or-later" \
      org.opencontainers.image.source="https://git.silkky.dev/ellie/piped-docker.git"