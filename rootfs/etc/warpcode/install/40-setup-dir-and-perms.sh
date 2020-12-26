#!/usr/bin/env sh

echo '
-------------------------------------
Setup directories and permissions
-------------------------------------'

for i in config data; do
    if [[ ! -d "/$i" ]]; then
        echo "creating /$i"
        mkdir "/$i"
        chown app:app "/$i"
    fi
done
