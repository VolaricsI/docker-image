#!/bin/sh
#
#	Create by Voli

	# futtatható programok beállítása és helyre mozgatása
    cd /defaults && chmod +x * && mv verzio /bin/ && mv start.sh / 	\
    || exit 2

    mkdir /tmp/resilio_dumps 		## Csak mert minden induláskor úgyis legyártja

	# Létrehozzuk az abc felhasználót
    /defaults/adduser-abc 	|| exit 2

    mkdir -p 		/config /downloads
    chown -RL abc:abc 	/config /downloads
