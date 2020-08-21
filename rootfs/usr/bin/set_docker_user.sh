#!/usr/bin/env sh

# Set the uid and gid of the docker user
# Set permissions and custom exec commands, if applicable
if [ "${PUID}" -ne 0 ]; then
    # Non-root needs su-exec to run the command
    set "su-exec" "docker" "$@"

    usermod -o -u "${PUID}" docker >/dev/null 2>&1
    groupmod -o -g "${PGID}" docker >/dev/null 2>&1

    for folder in config data; do
        if [ ! -d "/${folder}" ]; then
            # Skip non-existant folders
            true
        elif [ ! -f "/${folder}/.permissions-set" ]; then
            # First run
            touch "/${folder}/.permissions-set"
            chown -R docker:docker "/${folder}"
        elif [ "$(stat -c "%u" "/${folder}/.permissions-set")" -ne "${PUID}" ] || [ "$(stat -c "%g" "/${folder}/.permissions-set")" -ne "${PGID}" ]; then
            # Subsequent run, PUID/PGID changed from previous run
            echo "Resetting all permissions in directory \"/${folder}\" to UID/GID: ${PUID}/${PGID}"
            chown -R docker:docker "/${folder}"
        else
            # Subsequent run, PUID/PGID have not changed. Still chown the directory in case this is volume mounted (folder would otherwise be owned by root)
            chown docker:docker "/${folder}"
        fi
    done
else
    for folder in config data; do
        if [ -f "/${folder}/.permissions-set" ]; then
            chown root:root "/${folder}/.permissions-set"
        fi
    done
fi

echo "UID of docker user set to $(su-exec docker id -u)"
echo "GID of docker user set to $(su-exec docker id -g)"
