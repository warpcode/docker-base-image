#!/usr/bin/with-contenv sh

export PUID=${PUID:-911}
export PGID=${PGID:-911}
export TZ=${TZ:-Europe/London}
export UMASK=${UMASK:-0022}
export USERNAME=${USERNAME:-app}
export USERGROUP=${USERGROUP:-app}

# detect our privelage deescalation
# if command -v /sbin/su-exec > /dev/null
# then
#     SUEXEC="/sbin/su-exec"
# elif command -v /usr/bin/su-exec > /dev/null
# then
#     SUEXEC="/usr/bin/su-exec"
# elif command -v /usr/bin/gosu > /dev/null
# then
#     SUEXEC="/usr/bin/gosu"
# elif command -v /usr/sbin/gosu > /dev/null
# then
#     SUEXEC="/usr/sbin/gosu"
# else
#     echo "Unable to change process to default user"
#     exit 1
# fi

# detect our privelage deescalation
if command -v /bin/s6-dumpenv > /dev/null
then
    # Sync base variables for the rest of s6
    /bin/s6-dumpenv -- /var/run/s6/container_environment
fi
