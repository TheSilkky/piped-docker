ARG NODE_VERSION=lts
ARG ALPINE_VERSION=3.17
ARG CADDY_VERSION=2.6.3

####################################################################################################
## Builder
####################################################################################################
FROM node:${NODE_VERSION}-alpine${ALPINE_VERSION} AS builder

RUN apk add --no-cache \
    ca-certificates \
    git

ADD https://git.silkky.dev/api/v1/repos/github/Piped/git/refs/head /cachebreak
RUN git clone https://git.silkky.dev/github/Piped.git /piped-frontend

WORKDIR /piped-frontend

RUN yarn install --prefer-offline \
    && yarn build

####################################################################################################
## Final image
####################################################################################################
FROM caddy:${CADDY_VERSION}-alpine

COPY ./Caddyfile /etc/caddy/Caddyfile
COPY ./startup.sh /startup.sh
COPY --from=builder /piped-frontend/dist /srv

RUN chmod +x /startup.sh
CMD ["/startup.sh"]

LABEL org.opencontainers.image.title="Piped Frontend"
LABEL org.opencontainers.image.description="An alternative privacy-friendly YouTube frontend which is efficient by design."
LABEL org.opencontainers.image.licenses="AGPL-3.0-or-later"
LABEL org.opencontainers.image.source="https://git.silkky.dev/ellie/piped-docker.git"