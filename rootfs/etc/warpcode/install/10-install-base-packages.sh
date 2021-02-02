#!/usr/bin/env sh

PACKAGES=""
PACKAGES="${PACKAGES} bash"
PACKAGES="${PACKAGES} ca-certificates"
PACKAGES="${PACKAGES} curl"
PACKAGES="${PACKAGES} tzdata"

#
# Install base packages
#
if command -v apk > /dev/null
then
    PACKAGES="${PACKAGES} shadow"
    PACKAGES="${PACKAGES} ${EXTRA_PACKAGES_APK}"
elif  command -v apt-get > /dev/null
then
    PACKAGES="${PACKAGES} ${EXTRA_PACKAGES_APT}"

fi

PACKAGES="${PACKAGES} ${EXTRA_PACKAGES}"
pkg_install $PACKAGES
