#!/bin/sh
#
#	Create by Voli

	ConfFile=/etc/supervisord.conf 				## Alpine
	if [ -e ${ConfFile} ] ; then
		mv ${ConfFile} ${ConfFile}.orig
		ln -s /defaults/supervisord.conf ${ConfFile}
	fi

	ConfFile=/etc/supervisor/supervisord.conf 		## Ubuntu
	if [ -e ${ConfFile} ] ; then
		mv ${ConfFile} ${ConfFile}.orig
		ln -s /defaults/supervisord.conf ${ConfFile}
	fi
