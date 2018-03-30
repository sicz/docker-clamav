ARG BASE_IMAGE
FROM ${BASE_IMAGE}

ARG CLAMAV_VERSION

ENV \
  DOCKER_COMMAND="/usr/sbin/clamd"

RUN set -exo pipefail; \
  apk add --no-cache \
    "clamav>${CLAMAV_VERSION}" \
    "clamav-libunrar>${CLAMAV_VERSION}" \
    ; \
  clamd --version

# RUN set -exo pipefail; \
#   freshclam --verbose

COPY rootfs /
