#!/bin/sh
#
#	Create by Voli

    /defaults/adduser-abc || exit 1		## Ha kell akkor ujra alkotjuk az abc felhasználót


		# Jól álljanak a jogosultságok
    chown -RLc abc:abc 	/config
    chown -RLc abc 	/downloads

    echo Starting supervisord...

#exec /usr/bin/supervisord
    /usr/bin/supervisord			## Ezt használom az exec helyett mert így eltűnik ez a hibaüzenet: "...INFO reaped unknown pid..."
