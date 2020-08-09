#!/bin/sh
#
#	Create by Voli

[ -f /config/auth  ] && exit 0 								## Ha van akkor nincs mit csinálni - van/lesz configja

	D_USER=${DELUGE_USERNAME:=deluge}
	D_PASS=${DELUGE_PASSWORD:=deluge}

export LANG=en_US.UTF-8
update-locale

	echo "Doing initial setup..."

#	mkdir -p /config/state/
#	touch /config/state/torrents.state 						# Ne legyen hibaüzenet

	mkdir /config/In								# Innen fogja autómatán felemelni a torrenteket
	chown -Rc abc:abc 	/config

##### EZ CSAK AZÉRT MERT NEM KEZELI A STRINGEKET A deluge-console ; MÉG JELENLEG
	chpst -u  abc deluged -c /config 						# A megfelelő felhasználó configuráljon
	while [ ! -f /config/core.conf ]; do sleep 1; done 				# Így biztos lesz konfigja
	deluge-console -c /config "halt"; sleep 1					# Legyen ideje leállni

	sed -i 's|"download_location":.*,|"download_location": "/downloads",|'			/config/core.conf	# setup default paths to go to the user's defined data folder.
	sed -i 's|"move_completed_path":.*,|"move_completed_path": "/downloads",|'		/config/core.conf
	sed -i 's|"torrentfiles_location":.*,|"torrentfiles_location": "/config/Backup",|'	/config/core.conf

##A deluge-console programmal 
	chpst -u  abc deluged -c /config 						# A megfelelő felhasználó configuráljon
	while [ ! -f /config/core.conf ]; do sleep 1; done 					# Wait until auth file created.

	deluge-console -c /config "config -s allow_remote 		true"		# Nem csak a konténerből lehet managelni
	deluge-console -c /config "config -s copy_torrent_file 		true" 		# A feldolgozott torrentet elteszi későbbre
	deluge-console -c /config "config -s auto_managed 		false"
	deluge-console -c /config "config -s random_port 		false"

	deluge-console -c /config "halt"; sleep 1					# Legyen ideje leállni


	echo "Adding initial authentication details."
	echo "${D_USER}:${D_PASS}:10" 	>>/config/auth
