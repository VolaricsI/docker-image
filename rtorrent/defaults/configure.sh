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
    && chmod +x getupdate ellenorzes verzio plugins_disable plugins_install rtorrent-get-dir adduser-abc *.sh Stop 		\
    && mv       getupdate ellenorzes verzio plugins_disable plugins_install rtorrent-get-dir Stop 			 /bin/ 	\
    && mv start.sh / 	\
    || exit 2

	## supervisord sock file-ja
    rm /var/run/supervisor.sock 2>/dev/null; touch /tmp/supervisor.sock; ln -s /tmp/supervisor.sock /var/run/supervisor.sock


	## a default log-okat induláskor létrehozza/megnyitja és így (ha csinálja) akkor /tmp-ben változtat
    rm /var/log/php-fpm.log 	2>/dev/null; touch /tmp/php-fpm.log; 		ln -s /tmp/php-fpm.log 		/var/log/php-fpm.log
    rm /var/log/php7/error.log 	2>/dev/null; touch /tmp/php_error.log; 		ln -s /tmp/php_error.log 	/var/log/php7/error.log
    rm /var/log/nginx/error.log 2>/dev/null; touch /tmp/nginx_error.log; 	ln -s /tmp/nginx_error.log 	/var/log/nginx/error.log

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
