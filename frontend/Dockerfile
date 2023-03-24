ARG NODE_VERSION=lts
ARG ALPINE_VERSION=3.17
ARG CADDY_VERSION=2.6.3
ARG PIPED_FRONTEND_VERSION=750bbdb879b9b450a59c8e3d43c4af8d02cc947a

####################################################################################################
## Builder
####################################################################################################
FROM node:${NODE_VERSION}-alpine${ALPINE_VERSION} AS builder

ARG PIPED_FRONTEND_VERSION

RUN apk add --no-cache \
    ca-certificates \
    git

WORKDIR /piped-frontend

RUN git init \
    && git remote add origin https://git.silkky.dev/github/Piped.git \
    && git fetch origin ${PIPED_FRONTEND_VERSION} \
    && git reset --hard FETCH_HEAD

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