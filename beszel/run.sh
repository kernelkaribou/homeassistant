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
[ -n "${APP_URL}" ] && ARGS+=("APP_URL=${APP_URL}${INGRESS_ENTRY}")
sed -i "s#%%ingress_entry%%#${INGRESS_ENTRY}#g" /etc/nginx/servers/ingress.conf

# Enable auto login if provided
AUTO_LOGIN=$(bashio::config 'auto_login')
[ -n "${AUTO_LOGIN}" ] && ARGS+=("AUTO_LOGIN=${AUTO_LOGIN}")

# Add disable auth if requested
DISABLE_AUTH=$(bashio::config 'disable_auth')
[ "${DISABLE_AUTH}" = "true" ] && ARGS+=("DISABLE_PASSWORD_AUTH=true")

#Ingress config debug
cat /etc/nginx/servers/ingress.conf

# Checking Nginx Syntax
nginx -t -c /etc/nginx/nginx.conf

# Start NGINX
bashio::log.info "Starting NGINX..."
nginx &

# Start Beszel
bashio::log.info "Starting Beszel with args: ${ARGS[*]}"
exec "${ARGS[@]}" /usr/local/bin/beszel