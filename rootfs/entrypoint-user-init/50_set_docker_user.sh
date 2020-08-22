#!/usr/bin/env sh

# Set the uid and gid of the docker user
# Set permissions and custom exec commands, if applicable
if [ "${PUID}" -ne 0 ]; then
    # Non-root needs su-exec to run the command
    set "su-exec" "docker" "$@"

    usermod -o -u "${PUID}" docker >/dev/null 2>&1
    groupmod -o -g "${PGID}" docker >/dev/null 2>&1
fi

echo "UID of docker user set to $(su-exec docker id -u)"
echo "GID of docker user set to $(su-exec docker id -g)"
