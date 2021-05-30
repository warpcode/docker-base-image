#!/usr/bin/env sh

set -e
set -u

OVERLAY_ARCH=$(arch | sed 's/x86_64/amd64/g' | sed 's/armv7l/armhf/g')

URL_FETCH_OPTIONS=""
if [ "${IGNORE_CERTS:-0}" -eq "1" ]; then
    URL_FETCH_OPTIONS="-n"
fi

if [ -z "$S6_VERSION" ] || [ "$S6_VERSION" = "latest" ]; then
    S6_VERSION="$(url-fetch $URL_FETCH_OPTIONS "https://api.github.com/repos/just-containers/s6-overlay/releases/latest" | grep 'tag_name' | cut -d\" -f4)"

    if [ -z "$S6_VERSION" ]; then
        echo "Failed to grab the latest s6 version number"
        exit 1
    fi
fi

S6_TAR_URL="https://github.com/just-containers/s6-overlay/releases/download/${S6_VERSION}/s6-overlay-${OVERLAY_ARCH}.tar.gz"

echo "Downloading S6 Overlay ${S6_VERSION} for ${OVERLAY_ARCH}"
echo "Downloading from $S6_TAR_URL"
url-fetch $URL_FETCH_OPTIONS "$S6_TAR_URL" > /tmp/s6-overlay.tar.gz

echo "Extracting S6 Overlay"
tar xzf /tmp/s6-overlay.tar.gz -C / --exclude="./bin"
if [ -L /bin ]; then
    echo "/bin is a symlink, extracting to /usr/bin"
    tar xzf /tmp/s6-overlay.tar.gz -C /usr ./bin
else
    tar xzf /tmp/s6-overlay.tar.gz -C / ./bin
fi

echo "Cleaning up"
rm /tmp/s6-overlay.tar.gz

# Create the container environment dir so we can run scripts
# using with-contenv
/bin/s6-mkdir -pm 0755 -- /var/run/s6/container_environment
