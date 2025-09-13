#!/bin/sh
#
#	Create by Voli

		## Időzóna beállítása
    if [ ! -z ${TIME_ZONE} ]; then
	ln -nf /usr/share/zoneinfo/${TIME_ZONE} /etc/localtime && echo "${TIME_ZONE}" >/etc/timezone 	||exit 1
    fi
		## Az adatbázis nem kell; viszont ubuntu alatt kell a fent lévő csomagoknak!!
    [ -x /sbin/apk ] && apk del tzdata 	||exit 10

		## futtatható programok beállítása és helyre mozgatása
    cd /defaults 	\
    && chmod +x entrypoint.sh getupdate ellenorzes verzio healthcheck adduser-abc *.sh 		\
    && cp       entrypoint.sh getupdate ellenorzes verzio healthcheck 			 /bin/ 	\
    && mv start.sh entrypoint.sh /	\
    ||exit 20

	## Konfig file-ok helyükra
    cp /defaults/php-fpm.conf.example 	/config/php-fpm.conf	## Konfig file-ok
    cp /defaults/nginx.conf.example 	/config/nginx.conf
    cp /defaults/rtorrent.rc.example 	/config/rtorrent.rc

    mkdir -p /config/session

    mkdir -p /app/nginx /app/php-fpm				## Ezek az ideiglenes állományok helyek
    touch /var/log/nginx/error.log 				## nginx mindenképp létrehozza
    echo "/downloads" >/downloads/.docker-mount-point		## A letöltési könyvtár jelzője

		## A külömböző verziók miatt a chpst és php-fpm mindíg legyen ugyanott
    [ ! -e /sbin/chpst 	] && [ -e /usr/bin/chpst  ] && ln -s /usr/bin/chpst 	/sbin/chpst
    [ ! -e /sbin/chpst 	] && [ -e /usr/sbin/chpst ] && ln -s /usr/sbin/chpst 	/sbin/chpst

    Bin=$( ls /usr/sbin/php-fpm* )			## php-fpm több verzió lehet és folyamatosan frissítik
    [ -e $Bin 	] && ln -s $Bin /defaults/php-fpm

		## Ubuntu alatt máshol vannak (lehetnek) (később megcsinálni)
    [ ! -e /sbin/chpst 		] && exit 30
    [ ! -e /defaults/php-fpm 	] && exit 31

		## Létrehozzuk az abc felhasználót
    /defaults/adduser-abc 	|| exit 40

    date +%Y-%m-%d 	>/defaults/BuildDate.txt

    chown -RLc abc:abc 	/config /downloads /defaults
