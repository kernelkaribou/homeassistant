#!/bin/bash
# Build and test Dozzle addon locally

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ADDON_DIR="$SCRIPT_DIR"

# Get current version from config.yaml
CURRENT_VERSION=$(grep '^version:' "$ADDON_DIR/config.yaml" | sed 's/version: *"\?\([^"]*\)"\?/\1/')

# Check if version is provided as argument
if [ $# -eq 1 ]; then
    VERSION=$1
else
    VERSION=$CURRENT_VERSION
fi

echo "Building Dozzle addon version: $VERSION"

# Get latest Dozzle version from GitHub API
DOZZLE_VERSION=$(curl -s https://api.github.com/repos/amir20/dozzle/releases/latest | grep '"tag_name":' | sed -E 's/.*"tag_name": *"([^"]+)".*/\1/' | sed 's/^v//')

echo "Using Dozzle version: $DOZZLE_VERSION"

# Build the addon
docker build \
    --build-arg BUILD_FROM=ghcr.io/hassio-addons/base:18.1.3 \
    --build-arg BUILD_ARCH=amd64 \
    --build-arg BUILD_VERSION="$VERSION" \
    --build-arg DOZZLE_VERSION="v$DOZZLE_VERSION" \
    --tag "local/addon-dozzle:$VERSION" \
    --tag "local/addon-dozzle:latest" \
    "$ADDON_DIR"

echo ""
echo "Build completed! You can now run the addon with:"
echo "docker run --rm -it -p 8080:8080 -v /var/run/docker.sock:/var/run/docker.sock local/addon-dozzle:$VERSION"