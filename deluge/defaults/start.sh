#!/bin/sh

# set deluge user and group id
D_UID=${PUID:=1000}
D_GID=${PGID:=1000}

echo "Setting User and owner for config and data directories."
id abc 		2>/dev/null && deluser  abc 									## Ha van ilyen user vagy group töröljük,
id -g $D_GID 	2>/dev/null && delgroup abc

if [ "$ALAP" = "ubuntu" ]; then 										## hogy megfelelő ID-kel újra létrehozhassuk
    addgroup --system -gid $D_GID abc
    adduser --system  --disabled-password --no-create-home --home /tmp -uid $D_UID -gid $D_GID abc
else
    addgroup -S -g $D_GID abc
    adduser  -S -D -H -h /tmp -u $D_UID -G abc abc
fi


if [ ! -f /config/auth  ]; then								## Ha nincs konfigurálva akkor kap egy alapértelmezettet
	echo "Doing initial setup..."
	chown -R $D_UID:$D_GID 	/config
	chpst -u abc deluged -c /config							# A megfelelő user configuráljon

	while [ ! -f /config/auth ]; do sleep 1; done					# Wait until auth file created.

	deluge-console -c /config "config -s allow_remote True"				# allow remote access

	deluge-console -c /config "config -s download_location 		/downloads"	# setup default paths to go to the user's defined data folder.
	deluge-console -c /config "config -s move_completed_path 	/downloads"
	deluge-console -c /config "config -s torrentfiles_location 	/downloads"
	deluge-console -c /config "config -s autoadd_location 		/downloads"

	deluge-console -c /config "config -s random_port 		false"

	deluge-console -c /config "halt"; sleep 1				# Legyen ideje leállni

	echo "Adding initial authentication details."
	echo deluge:deluge:10 >>  /config/auth
fi


chown -R $D_UID:$D_GID 	/config
chown    $D_UID 	/downloads


	echo "Starting deluged..."

	umask $UMASK
	exec chpst -u abc 	/usr/bin/deluged --do-not-daemonize --config=/config $PRG_PARAM
