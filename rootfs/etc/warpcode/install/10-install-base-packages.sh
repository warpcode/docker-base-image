#!/usr/bin/env sh

PACKAGES=""
PACKAGES="${PACKAGES} ca-certificates"
PACKAGES="${PACKAGES} tzdata"

if ! command -v curl > /dev/null; then
    if ! command -v wget > /dev/null; then
        PACKAGES="${PACKAGES} curl"
    else
        # Upgrade
        PACKAGES="${PACKAGES} wget"
    fi
else
    # Upgrade
    PACKAGES="${PACKAGES} curl"
fi

if ! command -v bash > /dev/null; then
    PACKAGES="${PACKAGES} bash"
fi


#
# Install base packages
#
if command -v apk > /dev/null
then
    PACKAGES="${PACKAGES} shadow"

    if [ -n "${EXTRA_PACKAGES_APK:-}" ]; then
        PACKAGES="${PACKAGES} ${EXTRA_PACKAGES_APK}"
    fi
elif  command -v apt-get > /dev/null
then
    if [ -n "${EXTRA_PACKAGES_APT:-}" ]; then
        PACKAGES="${PACKAGES} ${EXTRA_PACKAGES_APT}"
    fi
fi

if [ -n "${EXTRA_PACKAGES:-}" ]; then
    PACKAGES="${PACKAGES} ${EXTRA_PACKAGES}"
fi


if [ -n "$PACKAGES" ]; then
    pkg-install $PACKAGES
fi

