#!/usr/bin/env sh

if [ "${PUID}" != "$(id -u ${USERNAME})" ]; then
    usermod -o -u "${PUID}" "${USERNAME}" > /dev/null 2>&1
    output_log "Setting UID to ${PUID}"
fi

if [ "${PGID}" != "$(id -g ${USERGROUP})" ]; then
    groupmod -o -g "${PGID}" "${USERGROUP}" > /dev/null 2>&1
    output_log "Setting GID to ${PGID}"
fi
