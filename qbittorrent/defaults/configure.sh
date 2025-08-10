#!/bin/sh
#
#	Create by Voli

		## Időzóna beállítása
    if [ ! -z ${TIME_ZONE} ]; then
	ln -nf /usr/share/zoneinfo/${TIME_ZONE} /etc/localtime && echo "${TIME_ZONE}" >/etc/timezone || exit 1
    fi
		## Az adatbázis nem kell; viszont ubuntu alatt kell a fent lévő csomagoknak!!
    [ -x /sbin/apk ] && apk del tzdata

		## A letöltési könyvtárba a szükséges file
    echo '/downloads' >/downloads/.docker-mount-point

		## futtatható programok beállítása és helyre mozgatása
    cd /defaults 				\
    && chmod +x adduser-abc *.sh verzio getupdate ellenorzes status healthcheck	\
    && mv getupdate ellenorzes status healthcheck 	 /bin/ 	\
    && mv start.sh /

		## A külömböző verziók miatt a chpst és mindíg legyen ugyanott
    [ ! -e /sbin/chpst 		] && [ -e /usr/bin/chpst  ] && ln -s /usr/bin/chpst 	/sbin/chpst
    [ ! -e /sbin/chpst 		] && [ -e /usr/sbin/chpst ] && ln -s /usr/sbin/chpst 	/sbin/chpst
    [ ! -e /sbin/chpst 		] && exit 3

		## Létrehozzuk az abc felhasználót
    /defaults/adduser-abc 	|| exit 6

    date +%Y-%m-%d 	>/defaults/BuildDate.txt

    mkdir -p 		/config /downloads /defaults
    chown -RLc abc:abc 	/config /downloads /defaults
