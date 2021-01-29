#!/usr/bin/with-contenv sh

[ ! -d /etc/cron.d ] && mkdir -p /etc/cron.d

if [ -n "$(ls -A /etc/cron.d 2>/dev/null)" ]
then
    # Only start cron if we have cron files
    rm -f /etc/services.d/cron/down
fi
