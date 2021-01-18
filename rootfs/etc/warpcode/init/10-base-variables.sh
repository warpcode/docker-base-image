#!/usr/bin/env sh

DEBUG_CONTAINER="${DEBUG_CONTAINER:-0}"
APP="${@:-sh}"
PUID=${PUID:-911}
PGID=${PGID:-911}
TZ=${TZ:-Europe/London}
UMASK=${UMASK:-0022}
USERNAME=${USERNAME:-app}
USERGROUP=${USERGROUP:-app}
