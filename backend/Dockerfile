ARG JAVA_VERSION=17

####################################################################################################
## Builder
####################################################################################################
FROM eclipse-temurin:${JAVA_VERSION}-jdk AS builder

RUN apt install -y \
    git

ADD https://git.silkky.dev/api/v1/repos/github/Piped-Backend/git/refs/head /cachebreak
RUN git clone https://git.silkky.dev/github/Piped-Backend.git /piped-backend

WORKDIR /piped-backend

RUN --mount=type=cache,target=/root/.gradle/caches/ \
    ./gradlew shadowJar \
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
    CMD wget --spider --q http://localhost:8080/healthcheck || exit 1

LABEL org.opencontainers.image.title="Piped Backend"
LABEL org.opencontainers.image.description="An alternative privacy-friendly YouTube frontend which is efficient by design."
LABEL org.opencontainers.image.licenses="AGPL-3.0-or-later"
LABEL org.opencontainers.image.source="https://git.silkky.dev/ellie/piped-docker.git"