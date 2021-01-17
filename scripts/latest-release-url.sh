#!/usr/bin/env sh

exec echo $(curl -s https://api.github.com/repos/warpcode/docker-base-image/releases/latest | grep 'browser_' | cut -d\" -f4)
