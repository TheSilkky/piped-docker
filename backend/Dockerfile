ARG JAVA_VERSION=17

####################################################################################################
## Builder
####################################################################################################
FROM eclipse-temurin:${JAVA_VERSION}-jdk-alpine AS builder

RUN apk add --no-cache \
    ca-certificates \
    git

ADD https://api.github.com/repos/TeamPiped/Piped-Backend/git/refs/head /cachebreak
RUN git clone https://github.com/TeamPiped/Piped-Backend.git /piped

WORKDIR /piped

RUN echo $(git log -1 --date=short --pretty=format:%cd)-$(git rev-parse --short HEAD) > VERSION \
    && ./gradlew shadowJar

####################################################################################################
### Final image
####################################################################################################
FROM eclipse-temurin:${JAVA_VERSION}-jre-alpine

RUN apk add --no-cache \
    ca-certificates \
    tini

WORKDIR /piped

COPY --from=builder /piped/build/libs/piped-1.0-all.jar /piped/piped.jar
COPY --from=builder /piped/VERSION /piped/VERSION

RUN touch /piped/config.properties

RUN adduser --disabled-password --gecos "" --no-create-home piped \
    && chown -R piped:piped /piped

USER piped

ENTRYPOINT ["/sbin/tini", "--"]

CMD ["java", "-jar", "/piped/piped.jar"]

EXPOSE 8080

STOPSIGNAL SIGTERM

HEALTHCHECK \
    --start-period=15s \
    --interval=1m \
    --timeout=5s \
    CMD wget --spider --q http://localhost:8080/healthcheck || exit 1

LABEL org.opencontainers.image.title="Piped Backend" \
      org.opencontainers.image.description="An alternative privacy-friendly YouTube frontend which is efficient by design. " \
      org.opencontainers.image.licenses="AGPL-3.0-or-later" \
      org.opencontainers.image.source="https://git.silkky.dev/ellie/piped-docker.git"