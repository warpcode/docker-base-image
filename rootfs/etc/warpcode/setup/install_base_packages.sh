#!/usr/bin/env bash

if command -v apk > /dev/null
then
    /usr/bin/pkg_install \
        bash \
        curl \
        tzdata \
        shadow \
        su-exec
elif  command -v apt-get > /dev/null
then
    /usr/bin/pkg_install \
        curl \
        tzdata \
        gosu
fi

/usr/bin/pkg_clean
