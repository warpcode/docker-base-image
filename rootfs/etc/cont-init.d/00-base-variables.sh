#!/usr/bin/with-contenv sh

export PUID=${PUID:-911}
export PGID=${PGID:-911}
export TZ=${TZ:-Europe/London}
export UMASK=${UMASK:-0022}
export USERNAME=${USERNAME:-app}
export USERGROUP=${USERGROUP:-app}
export HOME_ROOT="${HOME_ROOT:-/root/}"
export HOME_USER="${HOME_USER:-/home/$USERNAME}"
export URL_FETCH_IGNORE_CERTS=${URL_FETCH_IGNORE_CERTS:-0}

if [ "${SUPPRESS_BASE_VAR_DUMPENV:-0}" -eq 0 ]; then
    if command -v /bin/s6-dumpenv > /dev/null
    then
        # Sync base variables for the rest of s6
        /bin/s6-dumpenv -- /var/run/s6/container_environment
    fi
fi
