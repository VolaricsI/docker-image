#!/bin/bash

CONFIGDIR=/config
DATADIR=/downloads

# set deluge user and group id
USERNAME=btsync
D_UID=${PUID:=1000}
D_GID=${PGID:=1000}

echo "Setting user and owner for config and data directories."
userdel  --force $USERNAME 2>/dev/null							##Mindenképpen töröljük,
groupdel -f 	 $USERNAME 2>/dev/null
groupadd -g $D_GID $USERNAME								## hogy a megfelelő ID-vel újra létrehozhassuk
adduser --system --no-create-home --home /nonexistent --uid $D_UID --gid $D_GID $USERNAME

chown -R $D_UID:$D_GID $CONFIGDIR
chown    $D_UID $DATADIR

if [ ! -f $CONFIGDIR/sync.conf  ]; then							## Ha nincs konfig akkor kap egy alapot
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
