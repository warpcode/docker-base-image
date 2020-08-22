#!/usr/bin/env sh

echo "$@"

if [[ "$1" == "" ]]; then
    if [[ -f /bin/bash ]]; then
        set "/bin/bash"
    elif [[ -f /bin/sh ]]; then
        set "/bin/sh"
    fi
fi

for i in /entrypoint-user-init/*; do
    source "$i"
done

echo $@

exec $@
