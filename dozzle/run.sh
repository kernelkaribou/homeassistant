#!/usr/bin/with-contenv bashio
# ==============================================================================
# Home Assistant Add-on: Dozzle
# Runs Dozzle
# ==============================================================================

set -e

# Build command arguments
ARGS=()

REMOTE_HOST=$(bashio::config 'remote_host')
NO_ANALYTICS=$(bashio::config 'no_analytics')
ENABLE_ACTIONS=$(bashio::config 'enable_actions')
HOSTNAME=$(bashio::config 'hostname')
LEVEL=$(bashio::config 'level')
FILTER=$(bashio::config 'filter')

# Debug output
bashio::log.info "Configuration loaded:"
bashio::log.info "  REMOTE_HOST: ${REMOTE_HOST}"
bashio::log.info "  NO_ANALYTICS: ${NO_ANALYTICS}"
bashio::log.info "  ENABLE_ACTIONS: ${ENABLE_ACTIONS}"
bashio::log.info "  LEVEL: ${LEVEL}"

# Add remote host configuration if provided
if bashio::var.has_value "${REMOTE_HOST}"; then
    # Handle multiple remote hosts separated by commas
    IFS=',' read -ra HOST_ARRAY <<< "$REMOTE_HOST"
    for host in "${HOST_ARRAY[@]}"; do
        # Trim whitespace and add each host as separate argument
        host=$(echo "$host" | xargs)
        if [ -n "$host" ]; then
            ARGS+=(--remote-host "$host")
        fi
    done
fi

# Add hostname if provided
if bashio::var.has_value "${HOSTNAME}"; then
    ARGS+=(--hostname "${HOSTNAME}")
fi

# Add log level if provided
if bashio::var.has_value "${LEVEL}"; then
    ARGS+=(--level "${LEVEL}")
fi

# Add filter if provided
if bashio::var.has_value "${FILTER}"; then
    ARGS+=(--filter "${FILTER}")
fi

# Disable analytics if requested
if bashio::var.is_true "${NO_ANALYTICS}"; then
    ARGS+=(--no-analytics)
fi

# Enable actions if requested
if bashio::var.is_true "${ENABLE_ACTIONS}"; then
    ARGS+=(--enable-actions)
fi

# Determining ingress entry for base path
ingress_entry=$(bashio::addon.ingress_entry)
sed -i "s#%%ingress_entry%%#${ingress_entry}#g" /etc/nginx/servers/ingress.conf
ARGS+=(--base "${ingress_entry}")

# Start Dozzle
bashio::log.info "Starting Dozzle with args: ${ARGS[*]}"
exec /usr/bin/dozzle "${ARGS[@]}"

# Wait for dozzle to become available
bashio::net.wait_for 8080

# Start NGINX
bashio::log.info "Starting NGINX..."
exec nginx 