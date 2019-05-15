#!/bin/sh
#
#	Create by Voli

    /defaults/adduser-abc || exit 1		## Ha kell akkor ujra alkotjuk az abc felhasználót

if [ ! -f /config/auth  ]; then								## Ha nincs konfigurálva akkor kap egy alapértelmezettet
	echo "Doing initial setup..."
	chown -Rc abc:abc 	/config
	chpst -u  abc deluged -c /config						# A megfelelő user configuráljon

	while [ ! -f /config/auth ]; do sleep 1; done					# Wait until auth file created.

	deluge-console -c /config "config -s allow_remote True"				# Nem csak a konténerből lehet managelni

	deluge-console -c /config "config -s download_location 		/downloads"	# setup default paths to go to the user's defined data folder.
	deluge-console -c /config "config -s move_completed_path 	/downloads"
	deluge-console -c /config "config -s torrentfiles_location 	/downloads"
	deluge-console -c /config "config -s autoadd_location 		/downloads"

	deluge-console -c /config "config -s random_port 		false"

	deluge-console -c /config "halt"; sleep 1					# Legyen ideje leállni

	echo "Adding initial authentication details."
	echo deluge:deluge:10 >>  /config/auth
fi

    chown -R abc:abc 	/config
    chown    abc 	/downloads

	echo "Starting deluged..."

	umask $UMASK
	exec chpst -u abc:abc 	/usr/bin/deluged --do-not-daemonize --config=/config $PRG_PARAM
