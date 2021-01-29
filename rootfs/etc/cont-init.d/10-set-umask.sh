#!/usr/bin/with-contenv sh

if [ -n "${UMASK:-}" ]; then
    if [ "${UMASK}" != "$(umask)" ]; then
        s6-echo -- "[cont-init.d] Setting umask to ${UMASK} from $(umask)"
        umask ${UMASK}
    fi
fi
