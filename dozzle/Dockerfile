# Build arguments that need to be available across stages
ARG BUILD_FROM=ghcr.io/hassio-addons/base:18.1.3
ARG DOZZLE_VERSION=latest

# Multi-stage build to get Dozzle binary
FROM amir20/dozzle:${DOZZLE_VERSION} AS dozzle

# Use Home Assistant addon base image which includes bashio
FROM ${BUILD_FROM}

# Build arguments
ARG BUILD_ARCH
ARG BUILD_VERSION

# Copy Dozzle binary from official image
COPY --from=dozzle /dozzle /usr/bin/dozzle

# Make dozzle executable
RUN chmod +x /usr/bin/dozzle

# Labels
LABEL \
    io.hass.name="Dozzle" \
    io.hass.description="A simple, lightweight application that provides you with a web based interface to monitor your Docker container logs live, provided by https://dozzle.dev." \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version="${BUILD_VERSION}" \
    maintainer="KernelKaribou" \
    org.opencontainers.image.title="Dozzle" \
    org.opencontainers.image.description="A simple, lightweight application that provides you with a web based interface to monitor your Docker container logs live, provided by https://dozzle.dev." \
    org.opencontainers.image.source="https://github.com/kernelkaribou/homeassistant" \
    org.opencontainers.image.licenses="MIT"

# Copy run script
COPY run.sh /
RUN chmod a+x /run.sh

# Start Dozzle
CMD [ "/run.sh" ]