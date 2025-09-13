#!/bin/sh
#
#	Create by Voli

    cd /defaults

	## Ubuntu alatt is ugyanott legyen a program
    if [ ! -e /sbin/runsvdir ] ; then
	echo ln -s /usr/bin/runsvdir /sbin/runsvdir
	ls /usr/bin/runsvdir /sbin/runsvdir
	ln -s /usr/bin/runsvdir /sbin/runsvdir 						||exit 10
    fi

	## A szervizek valójában a /app alá kerülnek; Létrehozzuk a könyvtárakat
    rm -rf /etc/service && mkdir -p /app/runit && ln -s /app/runit /etc/service 	||exit 20

	##  és bemásoljuk ami kell a /app alá
    for neve in rtorrent nginx php-fpm ; do
		mkdir -p 			/etc/service/${neve}
		mv /defaults/runit_${neve}-run 	/etc/service/${neve}/run

		if [ -e runit_${neve}-finish ]; then mv runit_${neve}-finish /etc/service/${neve}/finish ;  fi
		if [ -e runit_${neve}-stop   ]; then mv runit_${neve}-stop   /etc/service/${neve}/stop   ;  fi

	done 			||exit 30
    chmod +x -Rc /etc/service/ 	||exit 40
