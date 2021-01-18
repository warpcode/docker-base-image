#!/usr/bin/env sh

if [ -n "${UMASK:-}" ]; then
    if [ "${UMASK}" != "$(umask)" ]; then
        output_log "Setting umask to ${UMASK} from $(umask)"
        umask ${UMASK}
    fi
fi
