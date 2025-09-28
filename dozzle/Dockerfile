# Multi-stage build to get Dozzle binary
ARG DOZZLE_VERSION=latest
FROM amir20/dozzle:${DOZZLE_VERSION} AS dozzle

# Use Alpine as base for Home Assistant addon
FROM alpine:3.19

# Install bashio for Home Assistant addon functionality
ARG BUILD_ARCH
ARG BUILD_VERSION

# Install dependencies
RUN apk add --no-cache \
    curl \
    jq \
    bash \
    tar \
    ca-certificates

# Set shell to bash
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install bashio
RUN curl -J -L -o /tmp/bashio.tar.gz \
    "https://github.com/hassio-addons/bashio/archive/v0.16.2.tar.gz" \
    && tar zxvf /tmp/bashio.tar.gz --strip 1 -C /tmp \
    && mv /tmp/lib /usr/lib/bashio \
    && ln -s /usr/lib/bashio/bashio /usr/bin/bashio \
    && rm -rf /tmp/*

# Copy Dozzle binary from official image
COPY --from=dozzle /dozzle /dozzle

# Create a non-root user
RUN addgroup -g 1000 dozzle && \
    adduser -D -s /bin/bash -u 1000 -G dozzle dozzle

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