#!/bin/sh
#
#	Create by Voli

    cd /defaults

	# Ubuntu alatt is ugyanott legyen a program
    [ ! -e /sbin/runsvdir ] && ln -s /usr/bin/runsvdir /sbin/runsvdir
	# Létrehozzuk a könyvtárakat és bemásoljuk ami kell
    rm -rf /etc/service 	\
    && 	for neve in rtorrent nginx php-fpm ; do
		mkdir -p 	/tmp/runit-supervise/${neve} /etc/service/${neve}
		ln -s 		/tmp/runit-supervise/${neve} /etc/service/${neve}/supervise
		ln -s /defaults/run_${neve} 	/etc/service/${neve}/run
		if [ -e run_${neve}-finish ]; then mv run_${neve}-finish /etc/service/${neve}/finish ;  fi
	done 	\
    && chmod +x -R 		/etc/service/ 			|| exit 12
