#!/bin/sh

CONFIGDIR=/config
DATADIR=/downloads
SETTING_RUTORRENT_DIR=$CONFIGDIR/rutorrent_settings

# set user name, user id and group id
USERNAME=torrent
D_UID=${PUID:=1000}
D_GID=${PGID:=1000}

echo "Setting User and owner for config and data directories."
id $USERNAME 2>/dev/null && deluser  $USERNAME			## Ha van ilyen user vagy group töröljük,
id -g $D_GID 2>/dev/null && delgroup $USERNAME
addgroup -S -g $D_GID $USERNAME					## hogy megfelelő ID-kel újra létrehozhassuk
adduser  -S -D -h /dev/null -u $D_UID -G $USERNAME $USERNAME

mkdir -p $CONFIGDIR $DATADIR
chown -R $D_UID:$D_GID $CONFIGDIR
chown    $D_UID $DATADIR

if [ ! -e /config/rtorrent/rtorrent.rc ]; then			## Ha nincs konfig akkor kap egy alapot + exapmle-ket
    mkdir -p /config/rtorrent
    cp /defaults/*.example /config/
    mv /config/rtorrent.rc.example /config/rtorrent/rtorrent.rc
fi

								## Az rtorrent-nek kellenek ezek a könyvtárak
    Dir_Session=$( grep "session = "      /config/rtorrent/rtorrent.rc |sed 's/.*[ =]//g;' )
    Dir_Watch=$(   grep "watch_directory" /config/rtorrent/rtorrent.rc |sed 's/.*=//g; s/\/\*.*//g; ' )
    mkdir -p ${Dir_Session} ${Dir_Watch}
    chown $USERNAME:$USERNAME -R /config

								## A rutorrent mentéseinek helye
    [ ! -d $SETTING_RUTORRENT_DIR ] && mkdir -p $SETTING_RUTORRENT_DIR
    chown -R nginx:www-data $SETTING_RUTORRENT_DIR

								## Plugin-ok kívülről történő beállítása
[ ".$DISABLE_PLUGINS" != "." ] && /defaults/disable_plugins "$DISABLE_PLUGINS"		## Plugins beállítás kívülről
[ ".$INSTALL"         != "." ] && apk add ffmpeg sox mediainfo unrar			## Minden további csomagot felrak

    echo Starting supervisord...

    /usr/bin/supervisord		## Ezt használom az exec helyett mert így eltűnik egy hibaüzenet: "...reaped unknown pid..."
#    exec /usr/bin/supervisord
