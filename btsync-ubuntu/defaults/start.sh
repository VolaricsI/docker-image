#!/bin/bash

CONFIGDIR=/config
DATADIR=/downloads

# set deluge user and group id
USERNAME=btsync
D_UID=${PUID:=1000}
D_GID=${PGID:=1000}

echo "Setting owner for config and data directories."
id $USERNAME >/dev/null && userdel --force --remove $USERNAME		##Ha van ilyen user töröljük, hogy megfelelő ID-vel újra létrehozhassuk
id -g $D_GID 2>/dev/null || groupadd -g $D_GID $USERNAME
id    $D_UID 2>/dev/null || adduser --system --uid $D_UID --gid $D_GID $USERNAME

chown -R $D_UID:$D_GID $CONFIGDIR
chown    $D_UID $DATADIR

if [ ! -d $CONFIGDIR ]; then
        echo "The config directory does not exist! Please add it as a volume."; exit 1
fi
if [ ! -d $DATADIR ]; then
        echo "The data directory does not exist! Please add it as a volume."; exit 1
fi

if [ ! -f $CONFIGDIR/sync.conf  ]; then
        echo "Doing initial setup."
        # Starting deluge
	cp /defaults/sync.conf.example $CONFIGDIR/sync.conf.example
	cp $CONFIGDIR/sync.conf.example $CONFIGDIR/sync.conf
	chown -R $D_UID:$D_GID $CONFIGDIR

fi

/bin/rslsync --help	## a verzio szám kiíratás miatt

echo "Starting resilio."
umask $UMASK 	>/dev/null
exec chpst -u $USERNAME 	/bin/rslsync --nodaemon --config $CONFIGDIR/sync.conf
