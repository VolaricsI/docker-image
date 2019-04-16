#!/bin/sh
#
#	Create by Voli

    if [ .$( cat /downloads/.docker-mount-point ) != ./downloads ]; then		## Csak akkor fusson ha VALÓBAN a megfelelő könyvtár van alatta
	echo "Nem megfelelő a csatolt könyvtár...."
	exit 1
    fi

    /defaults/adduser-abc || exit 1		## Ha kell akkor ujra alkotjuk az abc felhasználót


if [ ! -e /config/rtorrent.rc ]; then			## Ha nincs konfig akkor kap egy alapot + exapmle-ket
    cp /defaults/*.example /config/
    cp /config/rtorrent.rc.example /config/rtorrent.rc
fi

							## Az rtorrent-nek kellenek ezek a könyvtárak
    Dir_Session=$( grep "session = "      /config/rtorrent.rc |sed 's/.*[ =]//g;' )
    Dir_Watch=$(   grep "watch_directory" /config/rtorrent.rc |sed 's/.*=//g; s/\/\*.*//g; ' )
    mkdir -p ${Dir_Session} ${Dir_Watch}


					## Ha fut leállítom, de mindenképp törlöm a lock file-t mivel ha van akkor nem fog elindulni
    Lock_File=${Dir_Session}/rtorrent.lock
    if [ -e ${Lock_File} ]; then
	kill $( cat ${Lock_File} |sed 's/.*+//g' ) 	2>/dev/null
	rm ${Lock_File}
    fi


							## A rutorrent mentéseinek helye
    [ ! -d /config/rutorrent_watched  ] && mkdir -p /config/rutorrent_watched
    [ ! -d /config/rutorrent_settings ] && mkdir -p /config/rutorrent_settings
    [ ! -e /config/rutorrent_settings/plugins.ini ] && disable_plugins

		# Jól álljanak a jogosultságok
    chown -Rc abc:abc 	/config
    chown -Rc abc 	/downloads

							## Plugin-ok kívülről történő beállítása
[ ".$DISABLE_PLUGINS" != "." ] && disable_plugins "$DISABLE_PLUGINS"		## Plugins beállítás kívülről
[ ".$INSTALL"         != "." ] && apk add $PLUGIN_PRG_LIST			## Minden további csomagot felrak ami kell

    echo Starting supervisord...

#exec /usr/bin/supervisord
    /usr/bin/supervisord			## Ezt használom az exec helyett mert így eltűnik ez a hibaüzenet: "...INFO reaped unknown pid..."
