ARG NODE_VERSION=20.17.0
ARG ALPINE_VERSION=3.20
ARG NGINX_VERSION=1.27.1

####################################################################################################
## Get source code
####################################################################################################
FROM scratch AS source

ADD --keep-git-dir=true https://github.com/TeamPiped/Piped.git /piped

####################################################################################################
## Builder
####################################################################################################
FROM --platform=${BUILDPLATFORM} node:${NODE_VERSION}-alpine${ALPINE_VERSION} AS builder

RUN corepack enable pnpm && \
    apk add --no-cache \
    grep \
    curl

WORKDIR /piped

COPY --from=source /piped/pnpm-lock.yaml ./
RUN pnpm fetch

COPY --from=source /piped/package.json ./
RUN pnpm install --prefer-offline

COPY --from=source /piped ./
RUN pnpm build && \
    ./localizefonts.sh

####################################################################################################
## Final image
####################################################################################################
FROM --platform=${TARGETPLATFORM} nginxinc/nginx-unprivileged:${NGINX_VERSION}-alpine${ALPINE_VERSION}

COPY --from=builder --chown=nginx:nginx /piped/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --chmod=0755 entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
EXPOSE 8080

LABEL org.opencontainers.image.title="Piped Frontend"
LABEL org.opencontainers.image.description="An alternative privacy-friendly YouTube frontend which is efficient by design."
LABEL org.opencontainers.image.source="https://github.com/TheSilkky/piped-docker.git"