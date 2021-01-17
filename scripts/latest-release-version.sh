#!/usr/bin/env sh

exec echo $(curl -s https://api.github.com/repos/warpcode/docker-base-image/releases/latest | grep 'tag_name' | cut -d\" -f4)
