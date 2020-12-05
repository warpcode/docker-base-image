#!/usr/bin/env bash

OVERLAY_ARCH=$(arch | sed 's/x86_64/amd64/g' | sed 's/armv7l/armhf/g')
S6_VERSION=${S6_VERSION:-v2.1.0.2}
echo "Downloading S6 Overlay ${S6_VERSION} for ${OVERLAY_ARCH}"
curl -kfLo /tmp/s6-overlay.tar.gz -L "https://github.com/just-containers/s6-overlay/releases/download/${S6_VERSION}/s6-overlay-${OVERLAY_ARCH}.tar.gz"

echo "Extracting S6 Overlay"
tar xzf /tmp/s6-overlay.tar.gz -C / --exclude="./bin"

if [[ -L /bin ]]; then
    echo "/bin is a symlink, extracting to /usr/bin"
    tar xzf /tmp/s6-overlay.tar.gz -C /usr ./bin
else
    tar xzf /tmp/s6-overlay.tar.gz -C / ./bin
fi

echo "Cleaning up"
rm /tmp/s6-overlay.tar.gz
