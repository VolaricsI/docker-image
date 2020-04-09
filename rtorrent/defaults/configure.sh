#!/bin/sh
#
#	Create by Voli

	# Időzóna beállítása
    if [ ! -z ${TIME_ZONE} ]; then
	ln -nf /usr/share/zoneinfo/${TIME_ZONE} /etc/localtime && echo "${TIME_ZONE}" >/etc/timezone || exit 1
    fi
	## Az adatbázis nem kell; viszont ubuntu alatt kell a fent lévő csomagoknak!!
    [ -x /sbin/apk ] && apk del tzdata

	# futtatható programok beállítása és helyre mozgatása
    cd /defaults 	\
    && chmod +x getupdate ellenorzes verzio plugins_disable plugins_install adduser-abc *.sh Stop 		\
    && mv       getupdate ellenorzes verzio plugins_disable plugins_install Stop 			 /bin/ 	\
    && mv start.sh / 	\
    || exit 2

	## a default log-okat induláskor létrehozza/megnyitja és így (ha csinálja) akkor /tmp-ben változtat
    mkdir -p /var/log/php7
    rm /var/log/php-fpm.log 		2>/dev/null; touch /tmp/php-fpm.log; 		ln -s /tmp/php-fpm.log 		/var/log/php-fpm.log
    rm /var/log/php7/error.log 		2>/dev/null; touch /tmp/php_error.log; 		ln -s /tmp/php_error.log 	/var/log/php7/error.log
    rm /var/log/nginx/error.log 	2>/dev/null; touch /tmp/nginx_error.log; 	ln -s /tmp/nginx_error.log 	/var/log/nginx/error.log
    rm /var/log/nginx/access.log 	2>/dev/null; touch /tmp/nginx_access.log; 	ln -s /tmp/nginx_access.log 	/var/log/nginx/access.log

		## Ubuntu alatt máshol vannak
    [ ! -e /sbin/chpst 		] && ln -s /usr/bin/chpst 	/sbin/chpst
    [ ! -e /usr/sbin/php-fpm7 	] && ln -s /usr/sbin/php-fpm7.2 /usr/sbin/php-fpm7
    [ ! -e /sbin/chpst 		] && exit 40
    [ ! -e /usr/sbin/php-fpm7 	] && exit 41


#	## A php-fpm futtatóját beállítom (nem kell: közvetlenül indítom)
#    PhpFpmNeve=$( find /usr/sbin/ -executable|grep php-fpm )
#        ## Ubuntu
#    [ ! -e /usr/bin/php-fpm ] && [ -e "${PhpFpmNeve}" ] && ln -s ${PhpFpmNeve} /usr/bin/php-fpm
#    if [ ! -e /usr/bin/php-fpm ]; then
#	echo A php-fpm futtatóját nem sikerült beállítani...
#	exit 3
#    fi

    rm -rf /run && ln -s /tmp /run && mkdir /run/lock || exit 4

	# Létrehozzuk az abc felhasználót
    /defaults/adduser-abc 	|| exit 5

    date +%Y-%m-%d 	>/defaults/BuildDate.txt

    mkdir -p 		/config /downloads /defaults
    chown -RL abc:abc 	/config /downloads /defaults
