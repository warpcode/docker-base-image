#!/usr/bin/with-contenv sh

if [ -n "${PUID}" ] && [ -n "${PGID}" ]
then
    for i in config data /home/app; do
        if [ -d "/$i" ]
        then
            if [ "${PUID}:${PGID}" != "$(stat -c %u $i):$(stat -c %g $i)" ]
            then
                s6-echo -- "[cont-init.d] Setting owner of /$i to ${PUID}:${PGID}"
                chown ${PUID}:${PGID} "/$i"
            fi
        fi
    done
fi
