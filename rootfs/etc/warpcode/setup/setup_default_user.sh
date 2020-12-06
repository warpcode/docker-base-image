#!/usr/bin/env bash

USERNAME="app"
USERGROUP="app"

PUID=${PUID:-911}
PGID=${PGID:-911}

if command -v groupadd > /dev/null
then
    groupadd "$USERGROUP" -g "$PGID"
else
    addgroup -g "$PGID" "$USERGROUP"
fi

if command -v useradd > /dev/null
then
    useradd -u "$PUID" -g "$USERGROUP" "$USERNAME"
else
    adduser \
        --home "/home/$USERNAME" \
        --disabled-password \
        --gecos "" \
        --ingroup "$USERGROUP" \
        --uid "$PUID" \
        "$USERNAME"
fi

 mkdir -p "/home/$USERNAME"
 chown -R "${USERNAME}:${USERGROUP}" "/home/$USERNAME"
