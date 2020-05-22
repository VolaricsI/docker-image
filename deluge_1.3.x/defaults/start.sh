#!/bin/sh
#
#	Create by Voli

    /defaults/adduser-abc || exit 1		## Ha kell akkor ujra alkotjuk az abc felhasználót

    /defaults/config-deluge.sh 			## Ha kell legyártja az alap konfigot

	## A munin plugin-nek kell, hogy be tudjon jelentkezni a deluge-be.,,
    /defaults/setup-munin.sh

    chown -R abc:abc 	/config
    chown    abc 	/downloads

	echo "Starting deluged..."

	umask $UMASK
	exec chpst -u abc:abc 	/usr/bin/deluged --do-not-daemonize --config=/config $PRG_PARAM
