#!/bin/sh

# set deluge user and group id
D_UID=${PUID:=1000}
D_GID=${PGID:=1000}

echo "Setting User and owner for config and data directories."
id abc 		2>/dev/null && deluser  abc 								## Ha van ilyen user vagy group töröljük,
id -g $D_GID 	2>/dev/null && delgroup abc

if [ "$ALAP" = "ubuntu" ]; then 									## hogy megfelelő ID-kel újra létrehozhassuk
    addgroup --system -gid $D_GID abc
    adduser --system  --disabled-password --no-create-home --home /tmp -uid $D_UID -gid $D_GID abc
else
    addgroup -S -g $D_GID abc
    adduser  -S -D -H -h /tmp -u $D_UID -G abc abc
fi



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
    chown -RL $D_UID:$D_GID 	/config
    chown -RL $D_UID 		/downloads
    chown -RL nginx:www-data 	/var/www

							## Plugin-ok kívülről történő beállítása
[ ".$DISABLE_PLUGINS" != "." ] && disable_plugins "$DISABLE_PLUGINS"		## Plugins beállítás kívülről
[ ".$INSTALL"         != "." ] && apk add $PLUGIN_PRG_LIST			## Minden további csomagot felrak

    echo Starting supervisord...

#exec /usr/bin/supervisord
    /usr/bin/supervisord					## Ezt használom az exec helyett mert így eltűnik egy hibaüzenet: "...INFO reaped unknown pid..."
