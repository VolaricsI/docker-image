#!/bin/sh
#
#	Create by Voli

	# futtatható programok beállítása és helyre mozgatása
    cd /defaults && chmod +x * && mv getupdate verzio /bin/ && mv start.sh / || exit 1

	# Létrehozzuk az abc felhasználót
    /defaults/adduser-abc 	|| exit 2

    date +%Y-%m-%d 	>/defaults/BuildDate.txt

    rmdir /var/lib/boinc
    ln -s /config /var/lib/boinc

    mkdir -p 		/config
    chown -RL abc:abc 	/config
