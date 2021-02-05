#!/usr/bin/with-contenv sh
# vim: set ft=sh :

if [ "${CLEAN_TMP_DIR:-1}" -eq 1 ]; then
    rm -rf /tmp/*
fi
