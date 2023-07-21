#syntax=docker/dockerfile:1-labs
ARG JAVA_VERSION=17

####################################################################################################
## Builder
####################################################################################################
FROM --platform=${BUILDPLATFORM} eclipse-temurin:${JAVA_VERSION}-jdk AS builder

RUN apt update && apt install -y \
    --no-install-recommends \
    git

ADD --keep-git-dir=true https://github.com/TeamPiped/Piped-Backend.git /piped-backend

WORKDIR /piped-backend

RUN echo "$(git log -1 --date=short --pretty=format:%cd)-$(git rev-parse --short HEAD)" > VERSION && \
    ./gradlew shadowJar

####################################################################################################
### Final image
####################################################################################################
FROM eclipse-temurin:${JAVA_VERSION}-jre

COPY --from=builder /piped-backend/build/libs/piped-1.0-all.jar /opt/piped-backend/piped.jar
COPY --from=builder /piped-backend/VERSION /opt/piped-backend

RUN useradd --system --no-create-home --shell /sbin/nologin piped && \
    chown -R piped:piped /opt/piped-backend

USER piped

CMD ["java", "-server", "-Xmx1G", "-XX:+UnlockExperimentalVMOptions", "-XX:+OptimizeStringConcat", "-XX:+UseStringDeduplication", "-XX:+UseCompressedOops", "-XX:+UseNUMA", "-XX:+UseG1GC", "-Xshare:on", "-jar", "/opt/piped-backend/piped.jar"]

EXPOSE 8080

STOPSIGNAL SIGTERM

LABEL org.opencontainers.image.source="https://github.com/TeamPiped/Piped-Backend.git"
LABEL org.opencontainers.image.title="Piped Backend"
LABEL org.opencontainers.image.description="An alternative privacy-friendly YouTube frontend which is efficient by design."
LABEL org.opencontainers.image.licenses="AGPL-3.0-or-later"