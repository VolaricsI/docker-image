#!/bin/sh
#
#	Create by Voli

    if [ .$( cat /downloads/.docker-mount-point ) != ./downloads ]; then		## Csak akkor fusson ha VALÓBAN a megfelelő könyvtár van alatta
	echo "Nem megfelelő a csatolt könyvtár...."
	exit 1
    fi


    /defaults/adduser-abc || exit 1		## Ha kell akkor ujra alkotjuk az abc felhasználót

#		# Jól álljanak a jogosultságok
#    chown -RLc abc:abc 	/config
#    chown -RLc abc 	/downloads

    /defaults/start-lighttpd.sh &

    exec /defaults/start-rtorrent.sh
