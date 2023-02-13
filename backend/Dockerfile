ARG JAVA_VERSION=17
ARG PIPED_BACKEND_VERSION=cace6cce055d5c7f191544ce02b8a0a4170e8218

####################################################################################################
## Builder
####################################################################################################
FROM eclipse-temurin:${JAVA_VERSION}-jdk AS builder

ARG PIPED_BACKEND_VERSION

RUN apt update && apt install -y \
    git

WORKDIR /piped-backend

RUN git clone https://git.silkky.dev/github/Piped-Backend.git /piped-backend \
    && git checkout ${PIPED_BACKEND_VERSION}

RUN ./gradlew shadowJar \
    && echo $(git log -1 --date=short --pretty=format:%cd)-$(git rev-parse --short HEAD) > VERSION

####################################################################################################
### Final image
####################################################################################################
FROM eclipse-temurin:${JAVA_VERSION}-jre

WORKDIR /piped-backend

COPY --from=builder /piped-backend/build/libs/piped-1.0-all.jar /piped-backend/piped.jar
COPY --from=builder /piped-backend/VERSION /piped-backend/VERSION

RUN touch /piped-backend/config.properties

RUN adduser --disabled-password --gecos "" --no-create-home piped \
    && chown -R piped:piped /piped-backend

USER piped

CMD ["java", "-jar", "/piped-backend/piped.jar"]

EXPOSE 8080

STOPSIGNAL SIGTERM

HEALTHCHECK \
    --start-period=15s \
    --interval=1m \
    --timeout=5s \
    CMD wget --quiet http://localhost:8080/healthcheck || exit 1

LABEL org.opencontainers.image.title="Piped Backend"
LABEL org.opencontainers.image.description="An alternative privacy-friendly YouTube frontend which is efficient by design."
LABEL org.opencontainers.image.licenses="AGPL-3.0-or-later"
LABEL org.opencontainers.image.source="https://git.silkky.dev/ellie/piped-docker.git"