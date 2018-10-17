#!/usr/bin/env sh

set -x

				## A konténeren kívülről érkezik; Saját conf-nál ezt nem kell beállítani
[ ".$PHP_MEM" != "." ] && sed -i 's/memory_limit.*$/memory_limit = '$PHP_MEM'/g' /etc/php7/php.ini
[ ".$PHP_MEM" != "." ] && sed -i 's/memory_limit.*$/memory_limit = '$PHP_MEM'/g' /etc/php7/php-fpm.conf


    [ -e /config/php-fpm-rutorrent.conf ] && CONF_FILE=" --fpm-config /config/php-fpm-rutorrent.conf "

    mkdir -p /run/php /var/run/php

    exec php-fpm7 --nodaemonize --force-stderr $CONF_FILE
