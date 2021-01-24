#!/usr/bin/env sh

PACKAGES="dumb-init"
PACKAGES="${PACKAGES} curl"
PACKAGES="${PACKAGES} tzdata"

#
# Install base packages
#
if command -v apk > /dev/null
then
    PACKAGES="${PACKAGES} shadow"
    PACKAGES="${PACKAGES} su-exec"
    PACKAGES="${PACKAGES} ${EXTRA_PACKAGES_APK}"
elif  command -v apt-get > /dev/null
then
    PACKAGES="${PACKAGES} gosu"
    PACKAGES="${PACKAGES} ${EXTRA_PACKAGES_APT}"

fi

PACKAGES="${PACKAGES} ${EXTRA_PACKAGES}"
pkg_install $PACKAGES
