#!/bin/sh
#
#	Create by Voli

    cd /defaults

	# Létrehozzuk a könyvtárakat és bemásoljuk ami kell
       rm /etc/service && mkdir -p /etc/service/rtorrent/supervise /etc/service/nginx/supervise /etc/service/php-fpm/supervise 	\
    && mv run_rtorrent 		/etc/service/rtorrent/run 	\
    && mv run_rtorrent-finish 	/etc/service/rtorrent/finish 	\
    && mv run_nginx 		/etc/service/nginx/run 		\
    && mv run_php-fpm 		/etc/service/php-fpm/run 	\
    && chmod +x -R 		/etc/service/ 			|| exit 2
