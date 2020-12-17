#!/usr/bin/env sh

# detect our privelage deescalation
if command -v /sbin/su-exec > /dev/null
then
    SUEXEC="/sbin/su-exec"
elif command -v /usr/bin/su-exec > /dev/null
then
    SUEXEC="/usr/bin/su-exec"
elif command -v /usr/bin/gosu > /dev/null
then
    SUEXEC="/usr/bin/gosu"
elif command -v /usr/sbin/gosu > /dev/null
then
    SUEXEC="/usr/sbin/gosu"
else
    echo "Unable to change process to default user"
    exit 1
fi
