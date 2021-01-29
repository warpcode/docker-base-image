#!/usr/bin/env sh

#
# Setup initial Timezone
#
if [ -f "/usr/share/zoneinfo/${TZ}" ]; then
    if [ -f "/etc/localtime" ]; then
        rm -f /etc/localtime
    fi

    cp "/usr/share/zoneinfo/${TZ}" /etc/localtime
    echo "${TZ}" > /etc/timezone

    echo '
-------------------------------------
Set up Timezone
-------------------------------------'
echo "
Timezone set to ${TZ}
"
fi
