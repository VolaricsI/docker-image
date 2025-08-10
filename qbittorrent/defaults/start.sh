#!/bin/sh
#
#	Create by Voli

    /defaults/adduser-abc || exit 1		## Ha kell akkor ujra alkotjuk az abc felhasználót

    if [ .$( cat /downloads/.docker-mount-point ) != ./downloads ]; then		## Csak akkor fusson ha VALÓBAN a megfelelő könyvtár van alatta
	echo "Nem megfelelő a csatolt könyvtár...."
	exit 2
    fi

	## Jogosultság beállítása
    time find /config /www		! \( -user abc -a -group abc \) -exec chown -Lc abc:abc {} +
#    time find /downloads	! \( -user abc               \) -exec chown -Lc abc:    {} +

    umask $UMASK >/dev/null
    HOME=$(getent passwd abc | cut -d: -f6)

    mkdir -p /config/watch && chown -RLc abc:abc /config

    cd $HOME

    Param_WebUI_Port=${WebUI_Port:+webui-port="$WebUI_Port"}
    Param_Torrent_Port=${Torrent_Port:+--torrenting-port="$Torrent_Port"}
    Param_Log_Level=${LOG_LEVEL:+--log-level="$LOG_LEVEL"}


    exec /sbin/chpst -u abc:abc qbittorrent-nox --confirm-legal-notice 	\
		${Param_WebUI_Port} ${Param_Torrent_Port} ${Param_Log_Level}
