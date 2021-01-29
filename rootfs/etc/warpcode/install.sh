#!/usr/bin/env sh

set -e

INSTALL_SCRIPT_DIR=$(dirname $(readlink -f $0))

cat "${INSTALL_SCRIPT_DIR}/banner.txt"
. "/etc/cont-init.d/00-base-variables.sh"
for i in $(ls ${INSTALL_SCRIPT_DIR}/install/*.sh | sort -V)
do
    . "$i"
done

# Remove install dirs
rm -rf "${INSTALL_SCRIPT_DIR}/install"

# Remove this script
rm -f "$0"
