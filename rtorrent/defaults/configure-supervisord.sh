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

	
	Python3=$( apk list 2>/dev/null |grep -c ^python3 )
	if [ $Python3 -ne 0 ]; then
	    sed -i 's/python$/python3/' /defaults/run_watchdog.py
	fi
