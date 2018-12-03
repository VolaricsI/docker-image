#!/bin/sh

    [ -e /config/php-fpm-rutorrent.conf ] && CONF_FILE=" --fpm-config /config/php-fpm-rutorrent.conf "

    mkdir -p /run/php	##Néha kellhet

    exec php-fpm --nodaemonize --force-stderr $CONF_FILE
