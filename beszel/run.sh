#!/usr/bin/with-contenv bashio
# ==============================================================================
# Home Assistant Add-on: Beszel
# Runs Beszel
# ==============================================================================

set -e

# Build command arguments
ARGS=()

# Add app URL if provided
APP_URL=$(bashio::config 'app_url')
[ -n "${APP_URL}" ] && ARGS+=(--app-url "${APP_URL}")

# Add disable auth if requested
DISABLE_AUTH=$(bashio::config 'disable_auth')
[ "${DISABLE_AUTH}" = "true" ] && ARGS+=(--disable-auth)

# Determining ingress entry for base path
ingress_entry=$(bashio::addon.ingress_entry)
sed -i "s#%%ingress_entry%%#${ingress_entry}#g" /etc/nginx/servers/ingress.conf
ARGS+=(--base "${ingress_entry}")

#Ingress config debug
cat /etc/nginx/servers/ingress.conf

# Checking Nginx Syntax
nginx -t -c /etc/nginx/nginx.conf

# Start NGINX
bashio::log.info "Starting NGINX..."
nginx &

# Start Beszel
bashio::log.info "Starting Beszel with args: ${ARGS[*]}"
exec /usr/local/bin/beszel "${ARGS[@]}"