#!/usr/bin/with-contenv bashio
# ==============================================================================
# Home Assistant Add-on: Dozzle
# Runs Dozzle
# ==============================================================================

set -e

# Build command arguments
ARGS=()

# Add remote host configuration if provided
REMOTE_HOST=$(bashio::config 'remote_host')
if bashio::var.has_value "${REMOTE_HOST}"; then
    # Split on commas, trim whitespace and add each as --remote-host
    for host in ${REMOTE_HOST//,/ }; do
        host="$(echo "$host" | xargs)"
        [ -n "$host" ] && ARGS+=(--remote-host "$host")
    done
fi

# Add hostname if provided
HOSTNAME=$(bashio::config 'hostname')
[ -n "${HOSTNAME}" ] && ARGS+=(--hostname "${HOSTNAME}")

# Add log level if provided
LEVEL=$(bashio::config 'level')
[ -n "${LEVEL}" ] && ARGS+=(--level "${LEVEL}")

# Add filter if provided
FILTER=$(bashio::config 'filter')
[ -n "${FILTER}" ] && ARGS+=(--filter "${FILTER}")

# Disable analytics if requested
NO_ANALYTICS=$(bashio::config 'no_analytics')
[ "${NO_ANALYTICS}" = "true" ] && ARGS+=(--no-analytics)

# Enable actions if requested
ENABLE_ACTIONS=$(bashio::config 'enable_actions')
[ "${ENABLE_ACTIONS}" = "true" ] && ARGS+=(--enable-actions)

# Determining ingress entry for base path
ingress_entry=$(bashio::addon.ingress_entry)
sed -i "s#%%ingress_entry%%#${ingress_entry}#g" /etc/nginx/servers/ingress.conf
ARGS+=(--base "${ingress_entry}")

# Start Dozzle
bashio::log.info "Starting Dozzle with args: ${ARGS[*]}"
exec /usr/bin/dozzle "${ARGS[@]}"

# # Wait for dozzle to become available
# bashio::net.wait_for 8080

# Start NGINX
bashio::log.info "Starting NGINX..."
exec nginx 