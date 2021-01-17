#!/usr/bin/env sh

for i in config data; do
    if [ -d "/$i" ]; then
        output_log "Setting owner of /$i to ${PUID}:${PGID}"
        chown ${PUID}:${PGID} "/$i"
    fi
done
