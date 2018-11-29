#!/bin/bash

# set user id and group id
D_UID=${PUID:=1000}
D_GID=${PGID:=1000}

echo "Setting user and owner for config and data directories."
userdel  --force abc 2>/dev/null						##Mindenképpen töröljük,
groupdel --force abc 2>/dev/null
groupadd -g $D_GID abc								## hogy a megfelelő ID-vel újra létrehozhassuk
##adduser --system --no-create-home --home /tmp --uid $D_UID --gid $D_GID abc
adduser --system --no-create-home --uid $D_UID --gid $D_GID abc

mkdir -p /config /downloads
chown -R $D_UID:$D_GID 	/config
chown    $D_UID 	/downloads


[ ".$DISABLE_PLUGINS" != "." ] && /defaults/disable_plugins $DISABLE_PLUGINS		## Plugins beállítás kívülről


    [ ! -e /dev/console ] && ln -s /proc/1/fd/1 /dev/console		## A run-it így nem szól a hiánya miatt

    2>&1
	exec /sbin/runit
