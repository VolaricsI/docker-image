#!/bin/sh

##CONFIG_FILE=/config/rtorrent.rc

    supervisorctl status nginx
##    supervisorctl status nginx |grep RUNNING && [ -e /var/log/nginx/error.log ] && rm /var/log/nginx/error.log	## Ne legyen itt hiszen nem használjuk


					## Ha fut leállítom, de mindenképp törlöm a lock file-t mivel ha van akkor nem fog elindulni
    Lock_File=$( grep "session = " /config/rtorrent.rc |sed 's/.*[ =]//g;' )/rtorrent.lock
    if [ -e ${Lock_File} ]; then
	kill $(cat ${Lock_File} |sed 's/.*+//g')
	rm ${Lock_File}
    fi

    cd /tmp
    umask $UMASK 			# Csak ha van UMASK, különben csak kiírja

    exec chpst -u abc:abc /bin/sh -c "TERM=xterm exec /usr/bin/rtorrent -n -o import=/config/rtorrent.rc "
