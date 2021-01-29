#!/usr/bin/with-contenv sh

if [ -n "${TZ:-}" ]; then
    if [ "${TZ}" != "$(cat /etc/timezone)" ] && [ -f "/usr/share/zoneinfo/${TZ}" ]; then
        s6-echo --  "[cont-init.d] Setting Timezone to ${TZ} from $(cat /etc/timezone)"
        rm -f /etc/localtime
        cp "/usr/share/zoneinfo/${TZ}" /etc/localtime
        echo "${TZ}" > /etc/timezone
    fi
fi
