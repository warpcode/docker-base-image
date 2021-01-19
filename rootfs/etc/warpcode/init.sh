#!/usr/bin/env sh

set -e

for i in $(ls /etc/warpcode/init/*.sh | sort -V)
do
    output_log "Including file $i"
    . "$i"
done
