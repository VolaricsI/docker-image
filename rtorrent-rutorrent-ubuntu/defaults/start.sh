#!/bin/bash

CONFIGDIR=/config
DATADIR=/downloads

# set user name, user id and group id
USERNAME=rtorrent
D_UID=${PUID:=1000}
D_GID=${PGID:=1000}

echo "Setting user and owner for config and data directories."
userdel  --force $USERNAME 2>/dev/null							##Mindenképpen töröljük,
groupdel -f 	 $USERNAME 2>/dev/null
groupadd -g $D_GID $USERNAME								## hogy a megfelelő ID-vel újra létrehozhassuk
adduser --system --no-create-home --home /nonexistent --uid $D_UID --gid $D_GID $USERNAME

mkdir -p $CONFIGDIR
mkdir -p $DATADIR
chown -R $D_UID:$D_GID $CONFIGDIR
chown    $D_UID $DATADIR


[ ".DISABLE_PLUGINS" != "." ] /defaults/disable_plugins $DISABLE_PLUGINS		## Plugins beállítás kívülről


    ln -s /proc/1/fd/1 /dev/console		## A run-it nem szól a hiánya miatt
    2>&1
	exec /sbin/runit
