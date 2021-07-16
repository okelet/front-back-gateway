#!/bin/sh

set -e

ME=$(basename $0)

if [ -z "${DNS_RESOLVER}" ]; then
    FIRST_DNS_SERVER=$(cat /etc/resolv.conf | grep ^nameserver | head -n 1 | awk '{print $2}')
    if [ -z "${FIRST_DNS_SERVER}" ]; then
        echo "$ME: error: DNS_RESOLVER is empty, and couldn't guess current DNS server from /etc/resolv.conf." >&2
        exit 1
    else
        export DNS_RESOLVER="${FIRST_DNS_SERVER}"
    fi
fi

if [ -z "${FRONTEND_URL}" ]; then
    echo "$ME: error: \$FRONTEND_URL is empty." >&2
    exit 1
fi

if [ -z "${BACKEND_URL}" ]; then
    echo "$ME: error: \$BACKEND_URL is empty." >&2
    exit 1
fi

exec /docker-entrypoint.sh "$@"
