#!/bin/sh
#
#	Create by Voli

[ -f /config/auth  ] && exit 0 								## Ha van akkor nincs mit csinálni - van már config

	D_USER=${DELUGE_USERNAME:=deluge}
	D_PASS=${DELUGE_PASSWORD:=deluge}


	echo "Doing initial setup..."

	mkdir /config/state/
	touch /config/state/torrents.state 						# Ne legyen hibaüzenet

	mkdir /config/In								# Innen fogja autómatán felemelni a torrenteket
	chown -Rc abc:abc 	/config
	chpst -u  abc deluged -c /config 						# A megfelelő user configuráljon

	while [ ! -f /config/auth ]; do sleep 1; done 					# Wait until auth file created.

	deluge-console -c /config "config -s allow_remote True"				# Nem csak a konténerből lehet managelni

	deluge-console -c /config "config -s download_location 		/downloads"	# setup default paths to go to the user's defined data folder.
	deluge-console -c /config "config -s move_completed_path 	/downloads"
	deluge-console -c /config "config -s torrentfiles_location 	/downloads"
	deluge-console -c /config "config -s autoadd_enable 		true" 		# Felolvassa a torrent file-okat
	deluge-console -c /config "config -s autoadd_location 		/config/In"
	deluge-console -c /config "config -s copy_torrent_file 		true" 		# A feldolgozott torrentet elteszi későbbre
	deluge-console -c /config "config -s torrentfiles_location 	/config/Backup"

	deluge-console -c /config "config -s random_port 		false"

	deluge-console -c /config "halt"; sleep 1					# Legyen ideje leállni

	echo "Adding initial authentication details."

	echo "${D_USER}:${D_PASS}:10" 	>>/config/auth
