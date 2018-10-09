#!/bin/sh

CONFIGDIR=/config									#A használt könyvtárak
DATADIR=/downloads

USERNAME=deluge										# set user name, id and group id
D_UID=${PUID:=1000}
D_GID=${PGID:=1000}

    2>&1

echo "Setting user and owner for config and data directories."
userdel  --force $USERNAME 2>/dev/null							##Mindenképpen töröljük,
groupdel -f 	 $USERNAME 2>/dev/null
groupadd -g $D_GID $USERNAME								## hogy a megfelelő ID-vel újra létrehozhassuk
adduser --system --no-create-home --home /nonexistent --uid $D_UID --gid $D_GID $USERNAME

chown -R $D_UID:$D_GID $CONFIGDIR
chown    $D_UID $DATADIR

if [ ! -f $CONFIGDIR/auth  ]; then							## Ha nincs konfigurálva akkor kap egy alapértelmezettet
	echo "Doing initial setup..."
	chpst -u $USERNAME deluged -c $CONFIGDIR					# A megfelelő user configuráljon

	while [ ! -f $CONFIGDIR/auth ]; do sleep 1; done				# Wait until auth file created.

	deluge-console -c $CONFIGDIR "config -s allow_remote True"			# allow remote access

	deluge-console -c $CONFIGDIR "config -s download_location 	$DATADIR"	# setup default paths to go to the user's defined data folder.
	deluge-console -c $CONFIGDIR "config -s move_completed_path 	$DATADIR"
	deluge-console -c $CONFIGDIR "config -s torrentfiles_location 	$DATADIR"
	deluge-console -c $CONFIGDIR "config -s autoadd_location 	$DATADIR"

	deluge-console -c $CONFIGDIR "config -s random_port 		false"

	deluge-console -c $CONFIGDIR "halt"; sleep 1				# Legyen ideje leállni

	echo "Adding initial authentication details."
	echo deluge:deluge:10 >>  $CONFIGDIR/auth
fi

echo "Starting deluged..."
umask $UMASK 	>/dev/null
exec chpst -u $USERNAME 	/usr/bin/deluged --do-not-daemonize --config=${CONFIGDIR} $PRG_PARAM
