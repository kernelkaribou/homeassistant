#!/usr/bin/with-contenv bashio
# ==============================================================================
# Home Assistant Add-on: Beszel
# Runs Beszel
# ==============================================================================

set -e

# Build command arguments
ARGS=()

# Determining ingress entry for App URL and base path
INGRESS_ENTRY=$(bashio::addon.ingress_entry)
APP_URL=$(bashio::config 'app_url')
if [ -n "${APP_URL}" ]; then
    export APP_URL="${APP_URL}${INGRESS_ENTRY}"
fi
sed -i "s#%%ingress_entry%%#${INGRESS_ENTRY}#g" /etc/nginx/servers/ingress.conf

# Enable auto login if provided
AUTO_LOGIN=$(bashio::config 'auto_login')
if [ -n "${AUTO_LOGIN}" ]; then
    export AUTO_LOGIN="${AUTO_LOGIN}"
fi

# Add disable auth if requested
DISABLE_AUTH=$(bashio::config 'disable_auth')
if [ "${DISABLE_AUTH}" = "true" ]; then
    export DISABLE_PASSWORD_AUTH="true"
fi

#Ingress config debug
cat /etc/nginx/servers/ingress.conf

# Checking Nginx Syntax
nginx -t -c /etc/nginx/nginx.conf

# Start NGINX
bashio::log.info "Starting NGINX..."
nginx &

# Start Beszel
bashio::log.info "Starting Beszel..."
bashio::log.info "Environment variables set:"
[ -n "${APP_URL}" ] && bashio::log.info "  APP_URL=${APP_URL}"
[ -n "${AUTO_LOGIN}" ] && bashio::log.info "  AUTO_LOGIN=${AUTO_LOGIN}"
[ -n "${DISABLE_PASSWORD_AUTH}" ] && bashio::log.info "  DISABLE_PASSWORD_AUTH=${DISABLE_PASSWORD_AUTH}"

exec /usr/local/bin/beszel