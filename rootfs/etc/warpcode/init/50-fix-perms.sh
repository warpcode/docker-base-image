#!/usr/bin/env sh

for i in config data; do
    if [ -d "/$i" ]; then
        chown app:app "/$i"
    fi
done
