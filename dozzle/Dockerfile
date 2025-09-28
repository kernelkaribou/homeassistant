# Get the latest Dozzle version
ARG DOZZLE_VERSION=latest
FROM amir20/dozzle:${DOZZLE_VERSION}

# Install bashio for Home Assistant addon functionality
ARG BUILD_ARCH
ARG BUILD_VERSION

# Install dependencies (using default shell first)
RUN apk add --no-cache \
    curl \
    jq \
    bash \
    tar

# Set shell to bash after it's installed
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install bashio
RUN curl -J -L -o /tmp/bashio.tar.gz \
    "https://github.com/hassio-addons/bashio/archive/v0.16.2.tar.gz" \
    && tar zxvf /tmp/bashio.tar.gz --strip 1 -C /tmp \
    && mv /tmp/lib /usr/lib/bashio \
    && ln -s /usr/lib/bashio/bashio /usr/bin/bashio \
    && rm -rf /tmp/*

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