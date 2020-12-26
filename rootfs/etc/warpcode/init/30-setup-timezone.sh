#!/usr/bin/env sh

if [ -n "${TZ:-}" ]; then
    if [ "${TZ}" != "\$(cat /etc/timezone)" ] && [ -f "/usr/share/zoneinfo/\${TZ}" ]; then
        rm -f /etc/localtime
        cp "/usr/share/zoneinfo/${TZ}" /etc/localtime
        echo "${TZ}" > /etc/timezone
    fi
fi
