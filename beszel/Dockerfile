# Build arguments that need to be available across stages
ARG BUILD_FROM=ghcr.io/hassio-addons/base:18.1.3
ARG BESZEL_VERSION=latest

# Multi-stage build to get Beszel binary from GitHub Container Registry
FROM ghcr.io/henrygd/beszel/beszel:${BESZEL_VERSION} AS beszel

# Use Home Assistant addon base image which includes bashio
FROM ${BUILD_FROM}

# Build arguments
ARG BUILD_ARCH
ARG BUILD_VERSION

# Install required packages
RUN apk add --no-cache \
    nginx \
    ca-certificates

# Copy Beszel hub binary and web assets from official image
# The official image contains both the binary and web assets
COPY --from=beszel /app /app

# Make beszel executable (it should already be, but ensure it)
RUN chmod +x /app/beszel

# Labels
LABEL \
    io.hass.name="Beszel" \
    io.hass.description="Simple, lightweight server monitoring with Docker stats, historical data, and alerts. Provided by beszel.dev" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version="${BUILD_VERSION}" \
    maintainer="KernelKaribou" \
    org.opencontainers.image.title="Beszel" \
    org.opencontainers.image.description="Simple, lightweight server monitoring with Docker stats, historical data, and alerts. Provided by beszel.dev" \
    org.opencontainers.image.source="https://github.com/kernelkaribou/homeassistant" \
    org.opencontainers.image.licenses="MIT"

# Copy configuration files and run script
COPY rootfs/ /
COPY run.sh /
RUN chmod +x /run.sh

# Start Beszel
CMD [ "/run.sh" ]