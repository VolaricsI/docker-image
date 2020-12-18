#!/bin/sh
#
#	Create by Voli

	# futtatható programok beállítása és helyre mozgatása
    cd /defaults && chmod +x * && mv getupdate verzio /bin/ && mv start.sh / || exit 1

	# Létrehozzuk az abc felhasználót
    /defaults/adduser-abc 	|| exit 2

    date +%Y-%m-%d 	>/defaults/BuildDate.txt

    [ -d /var/lib/boinc 	] && rm -r /var/lib/boinc 			## Alpine
    [ -d /var/lib/boinc-client 	] && rm -r /var/lib/boinc-client 		## Ubuntu

    ln -s /config /var/lib/boinc
    ln -s /config /var/lib/boinc-client


    mkdir -p 		/config
    chown -RL abc:abc 	/config
