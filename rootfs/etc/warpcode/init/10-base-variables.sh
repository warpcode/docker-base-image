#!/usr/bin/env sh

DEBUG_CONTAINER="${DEBUG_CONTAINER:-0}"
APP="${@:-sh}"
TZ=${TZ:-Europe/London}
USERNAME=${USERNAME:-app}
USERGROUP=${USERGROUP:-app}
PUID=${PUID:-911}
PGID=${PGID:-911}
