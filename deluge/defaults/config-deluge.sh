#!/bin/sh
#
#	Create by Voli

[ -f /config/auth  ] && exit 0 								## Ha van akkor nincs mit csinálni - van/lesz configja

	D_USER=${DELUGE_USERNAME:=deluge}
	D_PASS=${DELUGE_PASSWORD:=deluge}

	echo "Doing initial setup..."

#	mkdir -p /config/state/
#	touch /config/state/torrents.state 						# Ne legyen hibaüzenet

	mkdir /config/In								# Innen fogja autómatán felemelni a torrenteket
	chown -Rc abc:abc 	/config

## Programozói hiba kijavítása....
	cp /usr/lib/python3/dist-packages/deluge/i18n/util.py 				/usr/lib/python3/dist-packages/deluge/i18n/util.py.orig
	cp /usr/lib/python3/dist-packages/deluge/ui/console/cmdline/commands/config.py 	/usr/lib/python3/dist-packages/deluge/ui/console/cmdline/commands/config.py.orig
	patch /usr/lib/python3/dist-packages/deluge/i18n/util.py 				</defaults/patch/util.py.patch
	patch /usr/lib/python3/dist-packages/deluge/ui/console/cmdline/commands/config.py 	</defaults/patch/config.py.patch
echo "1--------------------------------"


##A deluge-console programmal 
	chpst -u  abc deluged -c /config 						# A megfelelő felhasználó configuráljon
#	while [ ! -f /config/core.conf ]; do sleep 1; done 				# Wait until auth file created; Ekkor már elindult
	sleep 10 									# Biztos ami biztos

echo "2-------------------------------"
	deluge-console -c /config "config -s allow_remote 		true" 		# Nem csak a konténerből lehet managelni
	deluge-console -c /config "config -s auto_managed 		false"
	deluge-console -c /config "config -s random_port 		false"
	deluge-console -c /config "config -s copy_torrent_file 		true" 		# A feldolgozott torrentet elteszi későbbre
## str változók és csak a patch után megy
	deluge-console -c /config config -s download_location 		/downloads 	# Ide menti
	deluge-console -c /config config -s move_completed_path 	/downloads 	# és itt is marad
	deluge-console -c /config config -s torrentfiles_location 	/config/Backup 	# A torrent file-t ide is letárolja

	deluge-console -c /config "halt"; sleep 1					# Legyen ideje leállni

	echo "Adding initial authentication details."
	echo "${D_USER}:${D_PASS}:10" 	>>/config/auth
