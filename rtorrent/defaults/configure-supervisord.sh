#!/bin/sh
#
#	Create by Voli

    if [ -e /etc/supervisor/supervisord.conf ]; then 		## Ubuntu esetén
	mv /defaults/supervisord.ini /etc/supervisor/conf.d/supervisord.conf
#	sed -i 's/\/var\/log\/supervisor\/supervisord.log/\/proc\/1\/fd\/1/' /etc/supervisor/supervisord.conf
	mkdir -p /var/log/supervisor
    else							## alpine esetére
	mkdir -p /etc/supervisor.d
	mv /defaults/supervisord.ini /etc/supervisor.d/
    fi 	\
    || exit 3
