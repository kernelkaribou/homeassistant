#!/usr/bin/with-contenv bashio
# ==============================================================================
# Home Assistant Add-on: Dozzle
# Runs Dozzle
# ==============================================================================

# Build command arguments
ARGS=()

# Get configuration options
REMOTE_HOST=$(bashio::config 'remote_host')
REMOTE_USER=$(bashio::config 'remote_user')  
REMOTE_KEY=$(bashio::config 'remote_key')
NO_ANALYTICS=$(bashio::config 'no_analytics')
ENABLE_ACTIONS=$(bashio::config 'enable_actions')
HOSTNAME=$(bashio::config 'hostname')
BASE=$(bashio::config 'base')
LEVEL=$(bashio::config 'level')
AUTH_PROVIDER=$(bashio::config 'auth_provider')
AUTH_HEADER_USER=$(bashio::config 'auth_header_user')
AUTH_HEADER_EMAIL=$(bashio::config 'auth_header_email')
AUTH_HEADER_NAME=$(bashio::config 'auth_header_name')
FILTER=$(bashio::config 'filter')

# Add remote host configuration if provided
if bashio::var.has_value "${REMOTE_HOST}"; then
    ARGS+=(--remote-host "${REMOTE_HOST}")
    
    if bashio::var.has_value "${REMOTE_USER}"; then
        ARGS+=(--remote-user "${REMOTE_USER}")
    fi
    
    if bashio::var.has_value "${REMOTE_KEY}"; then
        ARGS+=(--remote-key "${REMOTE_KEY}")
    fi
fi

# Add hostname if provided
if bashio::var.has_value "${HOSTNAME}"; then
    ARGS+=(--hostname "${HOSTNAME}")
fi

# Add base path if provided
if bashio::var.has_value "${BASE}"; then
    ARGS+=(--base "${BASE}")
fi

# Add log level if provided
if bashio::var.has_value "${LEVEL}"; then
    ARGS+=(--level "${LEVEL}")
fi

# Add filter if provided
if bashio::var.has_value "${FILTER}"; then
    ARGS+=(--filter "${FILTER}")
fi

# Add authentication configuration
if bashio::var.equals "${AUTH_PROVIDER}" "forward-proxy"; then
    ARGS+=(--auth-provider forward-proxy)
    
    if bashio::var.has_value "${AUTH_HEADER_USER}"; then
        ARGS+=(--auth-header-user "${AUTH_HEADER_USER}")
    fi
    
    if bashio::var.has_value "${AUTH_HEADER_EMAIL}"; then
        ARGS+=(--auth-header-email "${AUTH_HEADER_EMAIL}")
    fi
    
    if bashio::var.has_value "${AUTH_HEADER_NAME}"; then
        ARGS+=(--auth-header-name "${AUTH_HEADER_NAME}")
    fi
fi

# Disable analytics if requested
if bashio::var.is_true "${NO_ANALYTICS}"; then
    ARGS+=(--no-analytics)
fi

# Enable actions if requested
if bashio::var.is_true "${ENABLE_ACTIONS}"; then
    ARGS+=(--enable-actions)
fi

# Set timeout
if bashio::var.has_value "${TIMEOUT}"; then
    ARGS+=(--timeout "${TIMEOUT}")
fi

# Set the web address, default to :8080 if not set
ARGS+=(--addr :8080)

bashio::log.info "Starting Dozzle with args: ${ARGS[*]}"

# Start Dozzle
exec /usr/local/bin/dozzle "${ARGS[@]}"