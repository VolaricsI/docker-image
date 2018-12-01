#!/bin/sh

# set deluge user and group id
D_UID=${PUID:=1000}
D_GID=${PGID:=1000}

echo "Setting User and owner for config and data directories."
id abc 		2>/dev/null && deluser  abc 								## Ha van ilyen user vagy group töröljük,
id -g $D_GID 	2>/dev/null && delgroup abc

if [ $ALAP == "ubuntu" ]; then 										## hogy megfelelő ID-kel újra létrehozhassuk
    addgroup --system -gid $D_GID abc
    adduser --system  --disabled-password --no-create-home --home /tmp -uid $D_UID -gid $D_GID abc
else
    addgroup -S -g $D_GID abc 					## hogy megfelelő ID-kel újra létrehozhassuk
    adduser  -S -D -H -h /tmp -u $D_UID -G abc abc
fi


if [ ! -f /config/sync.conf  ]; then				## Ha nincs konfig akkor kap egy alapértelmezettet
        echo "Doing initial setup."
	cd /config
	create_default_config >sync.conf.example
	cp sync.conf.example sync.conf
fi


chown -R $D_UID:$D_GID 	/config
chown    $D_UID 	/downloads


    echo "Starting resilio..."
    cd /tmp
    /usr/bin/rslsync --help |grep "Resilio Sync"		## a verzio kiíratás miatt
    rm -rf /tmp/.sync /tmp/*


    umask $UMASK

    exec chpst -u abc /usr/bin/rslsync --nodaemon --config /config/sync.conf
