#!/usr/bin/env sh

cat << 'EOF'
------------------------------------------------
_         __                             _
\ \      / /_ _ _ __ _ __   ___ ___   __| | ___
 \ \ /\ / / _` | '__| '_ \ / __/ _ \ / _` |/ _ \
  \ V  V | (_| | |  | |_) | (_| (_) | (_| |  __/
   \_/\_/ \__,_|_|  | .__/ \___\___/ \__,_|\___|
                    |_|

Brought you by https://github.com/warpcode
------------------------------------------------
EOF

#
# Variables
#
TZ=${TZ:-Europe/London}
USERNAME=${USERNAME:-app}
USERGROUP=${USERGROUP:-app}
PUID=${PUID:-911}
PGID=${PGID:-911}
DEBIAN_FRONTEND=${DEBIAN_FRONTEND:-noninteractive}

export DEBIAN_FRONTEND;

#
# Install base packages
#
if command -v apk > /dev/null
then
    apk add --no-cache \
        bash \
        curl \
        tzdata \
        shadow \
        su-exec \
        dumb-init
elif  command -v apt-get > /dev/null
then
    apt-get update
    apt-get install -y --no-install-recommends \
        curl \
        tzdata \
        gosu \
        dumb-init
    apt-get autoremove -y
    apt-get autoclean -y
    rm -rf /var/lib/apt/lists/*
fi

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
-------------------------------------
"
fi

#
# Install s6
#
# OVERLAY_ARCH=$(arch | sed 's/x86_64/amd64/g' | sed 's/armv7l/armhf/g')
# S6_VERSION=${S6_VERSION:-v2.1.0.2}
# echo "Downloading S6 Overlay ${S6_VERSION} for ${OVERLAY_ARCH}"
# curl -kfLo /tmp/s6-overlay.tar.gz -L "https://github.com/just-containers/s6-overlay/releases/download/${S6_VERSION}/s6-overlay-${OVERLAY_ARCH}.tar.gz"

# echo "Extracting S6 Overlay"
# tar xzf /tmp/s6-overlay.tar.gz -C / --exclude="./bin"

# if [[ -L /bin ]]; then
#     echo "/bin is a symlink, extracting to /usr/bin"
#     tar xzf /tmp/s6-overlay.tar.gz -C /usr ./bin
# else
#     tar xzf /tmp/s6-overlay.tar.gz -C / ./bin
# fi

# echo "Cleaning up"
# rm /tmp/s6-overlay.tar.gz

#
# Setup the init script
#
cat << EOF > /entry.sh
#!/usr/bin/env sh

#
# Setup default vars
#
APP="\${@:-sh}"
TZ=\${TZ:-$TZ}
USERNAME=\${USERNAME:-$USERNAME}
USERGROUP=\${USERGROUP:-$USERGROUP}
PUID=\${PUID:-$PUID}
PGID=\${PGID:-$PGID}

#
# Setup timezone
#
if [ -n "\${TZ:-}" ]; then
    if [ "\${TZ}" != "\$(cat /etc/timezone)" ] && [ -f "/usr/share/zoneinfo/\${TZ}" ]; then
        rm -f /etc/localtime
        cp "/usr/share/zoneinfo/\${TZ}" /etc/localtime
        echo "\${TZ}" > /etc/timezone
    fi
fi

#
# Setup user
#
if [ "\${PUID}" != "\$(id -u \${USERNAME})" ]; then
    usermod -o -u "\${PUID}" "\${USERNAME}" > /dev/null 2>&1
fi
if [ "\${PGID}" != "\$(id -g \${USERGROUP})" ]; then
    groupmod -o -g "\${PGID}" "\${USERGROUP}" > /dev/null 2>&1
fi

exec dumb-init \$APP
EOF
chmod 700 /entry.sh


cat << EOF > /entry-user.sh
#!/usr/bin/env sh

#
# Setup default vars
#
APP="\${@:-sh}"
PUID=\${PUID:-$PUID}
PGID=\${PGID:-$PGID}

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

exec /entry.sh "\${SUEXEC}" \${PUID}:\${PGID} \$APP
EOF
chmod 700 /entry-user.sh
