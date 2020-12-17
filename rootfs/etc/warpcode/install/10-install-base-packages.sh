#!/usr/bin/env sh

#
# Install base packages
#
if command -v apk > /dev/null
then
    # Alpine
    pkg_install \
        tzdata \
        shadow \
        su-exec \
        dumb-init
elif  command -v apt-get > /dev/null
then
    # Debian
    pkg_install \
        tzdata \
        gosu \
        dumb-init
fi

pkg_clean
