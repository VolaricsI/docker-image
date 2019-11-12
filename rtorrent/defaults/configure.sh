#!/bin/sh
#
#	Create by Voli

	# Időzóna beállítása
    if [ ! -z ${TIME_ZONE} ]; then
	ln -nf /usr/share/zoneinfo/${TIME_ZONE} /etc/localtime && echo "${TIME_ZONE}" >/etc/timezone || exit 1
    fi
	## Az adatbázis nem kell; viszont ubuntu alatt kell a fent lévő csomagoknak!!
    [ -x /sbin/apk 		] && apk del tzdata

	# futtatható programok beállítása és helyre mozgatása
    cd /defaults 	\
    && chmod +x getupdate ellenorzes verzio plugins_disable plugins_install rtorrent-get-dir adduser-abc *.sh 		\
    && mv       getupdate ellenorzes verzio plugins_disable plugins_install rtorrent-get-dir 			 /bin/ 	\
    && mv start.sh / 	\
    || exit 2


	## php-fpm a default log (ha van) a /tmp-ben menjen, mert induláskor létrehozza ha nincs
    rm /var/log/php-fpm.log 2>/dev/null; touch /tmp/php-fpm.log; ln -s /tmp/php-fpm.log /var/log/php-fpm.log

	## A php-fpm futtatóját beállítom
    PhpFpmNeve=$( find /usr/sbin/ -executable|grep php-fpm )
        ## Ubuntu
    [ ! -e /usr/bin/php-fpm ] && [ -e "${PhpFpmNeve}" ] && ln -s ${PhpFpmNeve} /usr/bin/php-fpm

    if [ ! -e /usr/bin/php-fpm ]; then
	echo A php-fpm futtatóját nem sikerült beállítani...
	exit 3
    fi


    rm -rf /run && ln -s /tmp /run && mkdir /run/lock || exit 4

    date +%Y-%m-%d 	>/defaults/BuildDate.txt

	# Létrehozzuk az abc felhasználót
    /defaults/adduser-abc 	|| exit 5


    mkdir -p 		/config /downloads /defaults
    chown -RL abc:abc 	/config /downloads /defaults
