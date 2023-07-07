# syntax=docker/dockerfile:1-labs

ARG NODE_VERSION=lts
ARG ALPINE_VERSION=3.17
ARG NGINX_VERSION=1.25.1

####################################################################################################
## Builder
####################################################################################################
FROM node:${NODE_VERSION}-alpine${ALPINE_VERSION} AS builder

RUN apk add --no-cache \
    ca-certificates \
    tzdata

ADD https://github.com/TeamPiped/Piped.git /piped

WORKDIR /piped

RUN corepack enable && \ 
    corepack prepare pnpm@latest --activate
    
RUN pnpm install --prefer-offline && \
    pnpm build

####################################################################################################
## Final image
####################################################################################################
FROM nginxinc/nginx-unprivileged:${NGINX_VERSION}-alpine${ALPINE_VERSION}

COPY --from=builder /piped/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --chmod=0755 entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]

CMD ["nginx", "-g", "daemon off;"]

EXPOSE 8080

LABEL org.opencontainers.image.source="https://github.com/TheSilkky/piped-docker.git"
LABEL org.opencontainers.image.title="Piped Frontend"
LABEL org.opencontainers.image.description="An alternative privacy-friendly YouTube frontend which is efficient by design."
LABEL org.opencontainers.image.licenses="AGPL-3.0-or-later"