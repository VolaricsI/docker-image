#!/usr/bin/env sh

set -x

CONFIG_FILE=/config/rtorrent/rtorrent.rc

USERNAME=torrent

    supervisorctl status nginx
    supervisorctl status nginx |grep RUNNING && [ -e /var/log/nginx/error.log ] && rm /var/log/nginx/error.log	## Ne legyen itt hiszen nem használjuk

					## Ha fut leállítom, de mindenképp törlöm a lock file-t mivel ha van akkor nem fog elindulni
    Lock_File=$( grep "session = " ${CONFIG_FILE} |sed 's/.*[ =]//g;' )/rtorrent.lock
    if [ -e ${Lock_File} ]; then
	kill $(cat ${Lock_File} |sed 's/.*+//g')
	rm ${Lock_File}
    fi

    2>&1
    cd /tmp
    umask $UMASK 			# Csak ha van UMASK, különben csak kiírja

    exec chpst -u $USERNAME:$USERNAME /bin/sh -c "TERM=xterm exec /usr/bin/rtorrent -n -o import=${CONFIG_FILE}"
