# syntax=docker/dockerfile:1-labs

ARG JAVA_VERSION=17

####################################################################################################
## Builder
####################################################################################################
FROM eclipse-temurin:${JAVA_VERSION}-jdk AS builder

RUN apt update && apt install -y \
    git

ADD --keep-git-dir=true https://github.com/TeamPiped/Piped-Backend.git /piped-backend

WORKDIR /piped-backend

RUN ./gradlew shadowJar \
    && echo $(git log -1 --date=short --pretty=format:%cd)-$(git rev-parse --short HEAD) > VERSION

####################################################################################################
### Final image
####################################################################################################
FROM eclipse-temurin:${JAVA_VERSION}-jre

WORKDIR /piped-backend

COPY --from=builder /piped-backend/build/libs/piped-1.0-all.jar ./piped.jar
COPY --from=builder /piped-backend/VERSION .

RUN touch config.properties \
    adduser --disabled-password --gecos "" --no-create-home piped \
    && chown -R piped:piped /piped-backend

USER piped

CMD ["java", "-server", "-Xmx1G", "-XX:+UnlockExperimentalVMOptions", "-XX:+OptimizeStringConcat", "-XX:+UseStringDeduplication", "-XX:+UseCompressedOops", "-XX:+UseNUMA", "-XX:+UseG1GC", "-Xshare:on", "-jar", "/piped-backend/piped.jar"]

EXPOSE 8080

STOPSIGNAL SIGTERM

HEALTHCHECK \
    --start-period=15s \
    --interval=1m \
    --timeout=5s \
    CMD wget --quiet http://localhost:8080/healthcheck || exit 1

LABEL org.opencontainers.image.source="https://git.silkky.dev/ellie/piped-docker.git"
LABEL org.opencontainers.image.title="Piped Backend"
LABEL org.opencontainers.image.description="An alternative privacy-friendly YouTube frontend which is efficient by design."
LABEL org.opencontainers.image.licenses="AGPL-3.0-or-later"