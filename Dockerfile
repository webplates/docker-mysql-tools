FROM alpine:3.8 AS downloader

RUN apk add --no-cache ca-certificates openssl

ARG MIGRATE_VERSION=4.2.1

RUN if [[ -z "$MIGRATE_VERSION" ]]; then echo "MIGRATE_VERSION argument MUST be set" && exit 1; fi

ENV DOWNLOAD_URL https://github.com/golang-migrate/migrate/releases/download/v$MIGRATE_VERSION/migrate.linux-amd64.tar.gz

RUN set -xe \
    && wget $DOWNLOAD_URL \
    && tar xvfz migrate.linux-amd64.tar.gz -C /tmp


FROM ubuntu:18.04

RUN apt-get update && apt-get install -y \
    mysql-client \
    mysql-utilities \
 && rm -rf /var/lib/apt/lists/*

COPY --from=downloader /tmp/migrate.linux-amd64 /usr/bin/migrate
