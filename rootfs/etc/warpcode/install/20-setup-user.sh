#!/usr/bin/env sh

#
# Setup the default user
#
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

echo '
-------------------------------------
Set up user GID/UID
-------------------------------------'
echo "
User name:   $USERNAME
User uid:    $(id -u "$USERNAME")
User group:  $USERGROUP
User gid:    $(id -g "$USERGROUP")
-------------------------------------
"
