#!/bin/sh

    [ -e /config/nginx.conf ] && EXTERNAL_CONF_FILE=" -c /config/nginx.conf "

    mkdir -p /run/nginx

    exec nginx -g 'daemon off; ' ${EXTERNAL_CONF_FILE}
