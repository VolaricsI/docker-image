#!/bin/sh

CONFIGDIR=/config
DATADIR=/downloads

    2>&1

# set deluge user and group id
USERNAME=btsync
D_UID=${PUID:=1000}
D_GID=${PGID:=1000}

echo "Setting User and owner for config and data directories."
id $USERNAME 2>/dev/null && deluser  $USERNAME			## Ha van ilyen user vagy group töröljük,
id -g $D_GID 2>/dev/null && delgroup $USERNAME
addgroup -S -g $D_GID $USERNAME					## hogy megfelelő ID-kel újra létrehozhassuk
adduser  -S -D -h /dev/null -u $D_UID -G $USERNAME $USERNAME

chown -R $D_UID:$D_GID $CONFIGDIR
chown    $D_UID $DATADIR

if [ ! -f $CONFIGDIR/sync.conf  ]; then				## Ha nincs konfig akkor kap egy alapértelmezettet
        echo "Doing initial setup."
        # Starting deluge
	cp /defaults/sync.conf.example $CONFIGDIR/sync.conf.example
	cp /defaults/sync.conf.example $CONFIGDIR/sync.conf
	chown -R $D_UID:$D_GID $CONFIGDIR

fi

    cd /tmp

    /usr/bin/rslsync --help |grep "Resilio Sync"		## a verzio kiíratás miatt

    rm -rf /tmp/.sync /tmp/*	# Az előző sor feleslegét takarítja el....

    echo "Starting resilio..."
    umask $UMASK

    exec chpst -u $USERNAME /usr/bin/rslsync --nodaemon --config $CONFIGDIR/sync.conf
