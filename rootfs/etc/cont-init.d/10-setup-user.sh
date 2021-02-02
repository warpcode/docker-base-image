#!/usr/bin/with-contenv sh

if [ -n "${PUID}" ] && [ "${PUID}" != "$(id -u ${USERNAME})" ]; then
    usermod -o -u "${PUID}" "${USERNAME}" > /dev/null 2>&1
    s6-echo -- "[cont-init.d] Setting ${USERNAME} UID to ${PUID}"
fi

if [ -n "${PGID}" ] && [ "${PGID}" != "$(id -g ${USERGROUP})" ]; then
    groupmod -o -g "${PGID}" "${USERGROUP}" > /dev/null 2>&1
    s6-echo -- "[cont-init.d] Setting ${USERGROUP} GID to ${PGID}"
fi
