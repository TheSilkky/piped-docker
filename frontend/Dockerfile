ARG NODE_VERSION=lts
ARG ALPINE_VERSION=3.16
ARG CADDY_VERSION=2.6.1

####################################################################################################
## Builder
####################################################################################################
FROM node:${NODE_VERSION}-alpine${ALPINE_VERSION} AS builder

RUN apk add --no-cache \
    ca-certificates \
    git

ADD https://api.github.com/repos/TeamPiped/Piped/git/refs/head /cachebreak
RUN git clone https://github.com/TeamPiped/Piped.git /piped-frontend

WORKDIR /piped-frontend

RUN yarn install --prefer-offline \
    && yarn build

####################################################################################################
## Final image
####################################################################################################
FROM caddy:${CADDY_VERSION}-alpine

COPY ./Caddyfile /etc/caddy/Caddyfile
COPY --from=builder /piped-frontend/dist /srv

LABEL org.opencontainers.image.title="Piped Frontend" \
      org.opencontainers.image.description="An alternative privacy-friendly YouTube frontend which is efficient by design. " \
      org.opencontainers.image.licenses="AGPL-3.0-or-later" \
      org.opencontainers.image.source="https://git.silkky.dev/ellie/piped-docker.git"