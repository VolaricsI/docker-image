#!/bin/sh
#
#	Create by Voli

	# Időzóna beállítása
    if [ ! -z ${TIME_ZONE} ]; then
	ln -nf /usr/share/zoneinfo/${TIME_ZONE} /etc/localtime && echo "${TIME_ZONE}" >/etc/timezone || exit 1
    fi
	## Az adatbázis ne kell; viszont ubuntu alatt kell a fent lévő csomagoknak!!
    [ -x /sbin/apk 		] && apk del tzdata

	# futtatható programok beállítása és helyre mozgatása
    cd /defaults 	\
    && chmod +x ellenorzes verzio plugins_disable plugins_install connect adduser-abc *.sh 	\
    && mv       ellenorzes verzio plugins_disable plugins_install connect /bin/ 			\
    && mv start.sh / 	\
    || exit 2

    rm -rf /run && ln -s /tmp /run || exit 3

    date +%Y-%m-%d 	>/defaults/BuildDate.txt

	# Létrehozzuk az abc felhasználót
    /defaults/adduser-abc 	|| exit 2

    mkdir -p 		/config /downloads
    chown -RL abc:abc 	/config /downloads /defaults

