#!/bin/sh
#
#	Create by Voli

    /defaults/adduser-abc || exit 1		## Ha kell akkor ujra alkotjuk az abc felhasználót

####################################################	## Csak akkor fusson ha VALÓBAN a megfelelő könyvtár van alatta
    if [ .$( cat /downloads/.docker-mount-point ) != ./downloads ]; then
	echo "Nem megfelelő a csatolt könyvtár...."
	exit 2
    fi

	## Jogosultság beállítása
    [ -e /dev/console ] && chown abc:abc /dev/console	2>&1 >/dev/null

    exec $@
