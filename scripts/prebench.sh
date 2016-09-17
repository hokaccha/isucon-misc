#!/bin/bash
set -ex

if [ -f /tmp/query.log ]; then
    sudo mv /tmp/query.log /tmp/query.log.$(date "+%Y%m%d_%H%M%S")
fi

if [ -f /var/log/nginx/access.log ]; then
    sudo mv /var/log/nginx/access.log /var/log/nginx/access.log.$(date "+%Y%m%d_%H%M%S")
fi
