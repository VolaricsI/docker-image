#!/bin/sh
#
#	Create by Voli

    if [ .$( cat /downloads/.docker-mount-point ) != ./downloads ]; then		## Csak akkor fusson ha VALÓBAN a megfelelő könyvtár van alatta
	echo "Nem megfelelő a csatolt könyvtár...."
	exit 1
    fi


    /defaults/adduser-abc || exit 1		## Ha kell akkor ujra alkotjuk az abc felhasználót


		##Ha meg van adva akkor ez lesz a web-es felület fejléce (title)
    [ -n "$[TITLE}" ] && sed -i "s/newTitle+=\"ruTorrent/newTitle+=\"${TITLE}/" /var/www/ruTorrent/js/webui.js


		# Jól álljanak a jogosultságok
    chown -RLc abc:abc 	/config
    chown -RLc abc 	/downloads

    exec /sbin/runsvdir /etc/service
