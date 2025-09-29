#!/usr/bin/with-contenv bashio
# ==============================================================================
# Home Assistant Add-on: Dozzle
# Runs Dozzle
# ==============================================================================

set -e

# Build command arguments
ARGS=()

# Get configuration options with fallback for missing bashio functions
get_config() {
    local key="$1"
    local default="$2"
    if command -v bashio::config >/dev/null 2>&1; then
        bashio::config "$key" "$default" 2>/dev/null || echo "$default"
    else
        echo "$default"
    fi
}

has_value() {
    local var="$1"
    if command -v bashio::var.has_value >/dev/null 2>&1; then
        bashio::var.has_value "$var" 2>/dev/null
    else
        [ -n "$var" ] && [ "$var" != "null" ]
    fi
}

is_true() {
    local var="$1"
    if command -v bashio::var.is_true >/dev/null 2>&1; then
        bashio::var.is_true "$var" 2>/dev/null
    else
        [ "$var" = "true" ] || [ "$var" = "1" ] || [ "$var" = "yes" ]
    fi
}

equals() {
    local var="$1"
    local value="$2"
    if command -v bashio::var.equals >/dev/null 2>&1; then
        bashio::var.equals "$var" "$value" 2>/dev/null
    else
        [ "$var" = "$value" ]
    fi
}

log_info() {
    local message="$1"
    if command -v bashio::log.info >/dev/null 2>&1; then
        bashio::log.info "$message"
    else
        echo "[INFO] $message"
    fi
}

REMOTE_HOST=$(get_config 'remote_host' '')
REMOTE_USER=$(get_config 'remote_user' '')
REMOTE_KEY=$(get_config 'remote_key' '')
NO_ANALYTICS=$(get_config 'no_analytics' 'true')
ENABLE_ACTIONS=$(get_config 'enable_actions' 'false')
HOSTNAME=$(get_config 'hostname' '')
BASE=$(get_config 'base' '')
LEVEL=$(get_config 'level' 'info')
AUTH_PROVIDER=$(get_config 'auth_provider' 'none')
AUTH_HEADER_USER=$(get_config 'auth_header_user' '')
AUTH_HEADER_EMAIL=$(get_config 'auth_header_email' '')
AUTH_HEADER_NAME=$(get_config 'auth_header_name' '')
FILTER=$(get_config 'filter' '')

# Debug output
log_info "Configuration loaded:"
log_info "  REMOTE_HOST: ${REMOTE_HOST}"
log_info "  NO_ANALYTICS: ${NO_ANALYTICS}"
log_info "  ENABLE_ACTIONS: ${ENABLE_ACTIONS}"
log_info "  LEVEL: ${LEVEL}"
log_info "  AUTH_PROVIDER: ${AUTH_PROVIDER}"

# Add remote host configuration if provided
if has_value "${REMOTE_HOST}"; then
    # Handle multiple remote hosts separated by commas
    IFS=',' read -ra HOST_ARRAY <<< "$REMOTE_HOST"
    for host in "${HOST_ARRAY[@]}"; do
        # Trim whitespace and add each host as separate argument
        host=$(echo "$host" | xargs)
        if [ -n "$host" ]; then
            ARGS+=(--remote-host "$host")
        fi
    done
    
    # Add remote user and key if provided (applies to all remote hosts)
    if has_value "${REMOTE_USER}"; then
        ARGS+=(--remote-user "${REMOTE_USER}")
    fi
    
    if has_value "${REMOTE_KEY}"; then
        ARGS+=(--remote-key "${REMOTE_KEY}")
    fi
fi

# Add hostname if provided
if has_value "${HOSTNAME}"; then
    ARGS+=(--hostname "${HOSTNAME}")
fi

# Add base path from ingress
base_path=$(bashio::config 'base' '')
if [ -z "$base_path" ]; then
    base_path=$X_INGRESS_PATH
fi
ARGS+=(--base "$base_path")

# Add log level if provided
if has_value "${LEVEL}"; then
    ARGS+=(--level "${LEVEL}")
fi

# Add filter if provided
if has_value "${FILTER}"; then
    ARGS+=(--filter "${FILTER}")
fi

# Add authentication configuration
if equals "${AUTH_PROVIDER}" "forward-proxy"; then
    ARGS+=(--auth-provider forward-proxy)
    
    if has_value "${AUTH_HEADER_USER}"; then
        ARGS+=(--auth-header-user "${AUTH_HEADER_USER}")
    fi
    
    if has_value "${AUTH_HEADER_EMAIL}"; then
        ARGS+=(--auth-header-email "${AUTH_HEADER_EMAIL}")
    fi
    
    if has_value "${AUTH_HEADER_NAME}"; then
        ARGS+=(--auth-header-name "${AUTH_HEADER_NAME}")
    fi
fi

# Disable analytics if requested
if is_true "${NO_ANALYTICS}"; then
    ARGS+=(--no-analytics)
fi

# Enable actions if requested
if is_true "${ENABLE_ACTIONS}"; then
    ARGS+=(--enable-actions)
fi

# Set the web address, default to :8080 if not set
ARGS+=(--addr '127.0.0.1:8080')

log_info "Starting Dozzle with args: ${ARGS[*]}"

# Start NGINX
nginx &

# Start Dozzle
exec /usr/bin/dozzle "${ARGS[@]}"