#!/bin/sh
#
#	Create by Voli

    /defaults/adduser-abc || exit 1		## Ha kell akkor ujra alkotjuk az abc felhasználót

    if [ .$( cat /downloads/.docker-mount-point ) != ./downloads ]; then		## Csak akkor fusson ha VALÓBAN a megfelelő könyvtár van alatta
	echo "Nem megfelelő a csatolt könyvtár...."
	exit 2
    fi

		##Ha meg van adva akkor ez lesz a web-es felület fejléce (title)
    [ -n "${TITLE}" ] && sed -i "s/\(newTitle+=\"\).*+self.version;/\1${TITLE}\";/" /tmp/webui.js

#################################################### php-fpm
    if [ ! -e /config/php-fpm.conf ]; then
	cp /defaults/php-fpm.conf.example /config/
	cp /defaults/php-fpm.conf.example /config/php-fpm.conf
    fi
    [ -e /tmp/php-fpm.sock ] && rm /tmp/php-fpm.sock 		##A régi socket biztossan nem kell

#################################################### nginx
    if [ ! -e /config/nginx.conf ]; then
	cp /defaults/nginx.conf.example /config/
	cp /defaults/nginx.conf.example /config/nginx.conf
    fi

#################################################### rtorrent
    if [ ! -e /config/rtorrent.rc ]; then
	cp /defaults/rtorrent.rc.example* /config/
	cp /defaults/rtorrent.rc.example  /config/rtorrent.rc
    fi
    mkdir -p /config/rutorrent_settings /config/watched

    Session_Dir=$( grep -v "#" /config/rtorrent.rc 	|grep "^session.*=" 	|head -1 |sed 's/.*[ =]//' )
    [ -e "${Session_Dir}/rtorrent.lock" ] && rm ${Session_Dir}/rtorrent.lock

#    time chown -RLc abc:abc 	/config /var/www/* /dev/console 			# Jól álljanak a jogosultságok
#    time chown -RLc abc: 	/downloads
    time find /config /var/www /dev/console 	! \( -user abc -a -group abc \) -exec chown -Lc abc:abc {} +
    time find /downloads			! \( -user abc -a -group abc \) -exec chown -Lc abc:    {} +

    umask $UMASK >/dev/null
    HOME=/config
    cd /config/

exec 	/usr/bin/supervisord --nodaemon --configuration /defaults/supervisord.conf 	## Ha supervisord-ben loglevel=warn (nem info/default) akkor nincs "...INFO reaped unknown pid..."
