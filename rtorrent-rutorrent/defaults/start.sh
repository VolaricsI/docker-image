#!/bin/sh
#
#	Create by Voli

    /defaults/adduser-abc || exit 1		## Ha kell akkor ujra alkotjuk az abc felhasználót


if [ ! -e /config/rtorrent.rc ]; then			## Ha nincs konfig akkor kap egy alapot + exapmle-ket
    cp /defaults/*.example /config/
    cp /config/rtorrent.rc.example /config/rtorrent.rc
fi

							## Az rtorrent-nek kellenek ezek a könyvtárak
    Dir_Session=$( grep "session = "      /config/rtorrent.rc |sed 's/.*[ =]//g;' )
    Dir_Watch=$(   grep "watch_directory" /config/rtorrent.rc |sed 's/.*=//g; s/\/\*.*//g; ' )
    mkdir -p ${Dir_Session} ${Dir_Watch}


							## A rutorrent mentéseinek helye
    [ ! -d /config/rutorrent_settings ] && mkdir -p /config/rutorrent_settings
    [ ! -d /config/rutorrent_watched  ] && mkdir -p /config/rutorrent_watched


		# Jól álljanak a jogosultságok
    chown -RL abc:abc 	/config
    chown -RL abc 	/downloads
    chown -RL abc:abc 	/var/www

							## Plugin-ok kívülről történő beállítása
[ ".$DISABLE_PLUGINS" != "." ] && disable_plugins "$DISABLE_PLUGINS"		## Plugins beállítás kívülről
[ ".$INSTALL"         != "." ] && apk add $PLUGIN_PRG_LIST			## Minden további csomagot felrak

    echo Starting supervisord...

#exec /usr/bin/supervisord
    /usr/bin/supervisord					## Ezt használom az exec helyett mert így eltűnik egy hibaüzenet: "...INFO reaped unknown pid..."
