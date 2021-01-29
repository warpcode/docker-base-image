#!/usr/bin/env sh

OVERLAY_ARCH=$(arch | sed 's/x86_64/amd64/g' | sed 's/armv7l/armhf/g')

if [ "$S6_VERSION" == 'latest' ]; then
    S6_VERSION="$(curl -s https://api.github.com/repos/just-containers/s6-overlay/releases/latest | grep 'tag_name' | cut -d\" -f4)"
fi

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
