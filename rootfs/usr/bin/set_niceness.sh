#!/usr/bin/env sh

# Set niceness if defined
if [ -n "${NICENESS:-}" ]; then
    # NOTE: On debian systems, nice always has an exit code of `0`, even when
    # permission is denied. Look for the error message instead.
    if [ "$($(command -v nice) -n "${NICENESS}" true 2>&1)" != "" ]; then
        echo "ERROR: Permission denied to set application's niceness to" \
            "'${NICENESS}'. Make sure the container is started with the" \
            "'--cap-add=SYS_NICE' option. Exiting..."
        exit 1
    fi
    echo "Niceness set to ${NICENESS}"
    set "$(command -v nice)" "-n" "${NICENESS}" "$@"
fi
