#!/usr/bin/env sh

# Set the timezone if specified
if [ -n "${TZ:-}" ]; then
    if [ -f "/usr/share/zoneinfo/${TZ}" ]; then
        rm -f /etc/localtime
        cp "/usr/share/zoneinfo/${TZ}" /etc/localtime
        echo "${TZ}" >/etc/timezone
        echo "Timezone set to ${TZ}"
    else
        echo "Environment variable TZ (${TZ}) is invalid, ignoring..."
    fi
else
    echo "Environment variable TZ is not set, ignoring..."
fi
