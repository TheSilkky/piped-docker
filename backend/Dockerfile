ARG JAVA_VERSION=21
ARG UID=911
ARG GID=911

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

ARG UID
ARG GID

WORKDIR /opt/piped-backend

COPY --from=builder /piped-backend/build/libs/piped-1.0-all.jar /opt/piped-backend/piped.jar
COPY --from=builder /piped-backend/VERSION /opt/piped-backend
COPY --chmod=0755 entrypoint.sh /opt/piped-backend

RUN groupadd --system --gid ${GID} piped && \
    useradd --system --gid ${GID} --uid ${UID} --shell /sbin/nologin piped && \
    chown -R piped:piped /opt/piped-backend

USER piped
ENTRYPOINT ["/opt/piped-backend/entrypoint.sh"]
EXPOSE 8080
STOPSIGNAL SIGTERM

LABEL org.opencontainers.image.title="Piped Backend"
LABEL org.opencontainers.image.description="An alternative privacy-friendly YouTube frontend which is efficient by design."
LABEL org.opencontainers.image.source="https://github.com/TheSilkky/piped-docker.git"