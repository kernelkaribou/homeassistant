ARG BUILD_FROM
FROM ${BUILD_FROM}

# Get the latest Dozzle version
ARG DOZZLE_VERSION
FROM amir20/dozzle:${DOZZLE_VERSION:-latest}

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

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

CMD [ "/run.sh" ]