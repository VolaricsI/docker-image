#!/usr/bin/env sh
set -x

CONF_FILE=/etc/nginx/sites-enabled/nginx-rutorrent.conf
PWD_FILE=/config/htpasswd

## Hitelesítés beállítása: Ha nincs saját konfig és létezik a htpasswd file
    [ -e /config/nginx.conf ] || [ -e $PWD_FILE ] && sed -i 's/.*\(auth_basic .*\)/\1/g;     s/.*\(auth_basic_user_file \)/\1/g; ' 	$CONF_FILE
    [ -e /config/nginx.conf ] || [ -e $PWD_FILE ] || sed -i 's/.*\(auth_basic .*\)/##\t\1/g; s/.*\(auth_basic_user_file \)/##\t\1/g; ' 	$CONF_FILE


    [ -e /config/nginx.conf ] && EXTERNAL_CONF_FILE=" -c /config/nginx.conf "

    mkdir -p /run/nginx

    exec nginx -g 'daemon off; ' ${EXTERNAL_CONF_FILE}
