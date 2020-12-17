#!/usr/bin/env sh

set -e

INSTALL_SCRIPT_DIR=$(dirname $(readlink -f $0))

cat "${INSTALL_SCRIPT_DIR}/banner.txt"
. "${INSTALL_SCRIPT_DIR}/init/10-base-variables.sh"
for i in $(ls ${INSTALL_SCRIPT_DIR}/install/*.sh | sort -V)
do
    . "$i"
done
