#!/bin/sh

D_UID=${PUID:=1000}			## set user and group id
D_GID=${PGID:=1000}

UMASK=${UMASK:-022}
WEBUI_PORT=${WEBUI_PORT:-8080}

echo "Setting User..."
    id abc 2>/dev/null && deluser  abc			## Ha van ilyen user vagy group töröljük,
    id -g $D_GID 2>/dev/null && delgroup abc
    addgroup -S -g $D_GID abc				## hogy megfelelő ID-kel újra létrehozhassuk
    adduser  -S -D -h /tmp -u $D_UID -G abc abc

if [ ! -e /config/config/qBittorrent.conf ]; then	## Ha nincs konfig kap egy alapot
    echo "Copy default/minimal configure file..."
    mkdir -p /config/config
    cp /defaults/qBittorrent.conf /config/config
fi

echo A log a konzolra iranyitva...
    [ -e /config/data/logs/qbittorrent.log ] && rm /config/data/logs/qbittorrent.log
    [ ! -d /config/data/logs ] && mkdir -p /config/data/logs/
    ln -s /proc/1/fd/1 /config/data/logs/qbittorrent.log

echo "Setting owner for config and data directories."
    chown -R $D_UID:$D_GID 	/config
    chown    $D_UID 		/downloads
    umask "$UMASK"

echo "Starting qbittorrent..."
    exec chpst -u abc:abc qbittorrent-nox --profile=/ --webui-port="${WEBUI_PORT}"
