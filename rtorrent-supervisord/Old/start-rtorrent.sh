#!/bin/sh

if [ ! -e /config/rtorrent.rc ]; then			## Ha nincs konfig akkor kap egy alapot + exapmle-ket
    cp /defaults/*.example /config/
    cp /config/rtorrent.rc.example /config/rtorrent.rc
fi

			## Az rtorrent-nek kellenek ezek a könyvtárak; csak a /config alá érdemes tenni
    Dir_Session=$( grep "session.*=" 		/config/rtorrent.rc |sed 's/.*[ =]//g; ' )
    Dir_Watch=$(   grep "watch_directory.*=" 	/config/rtorrent.rc |sed 's/.*=//g; s/\/\*.*//g; ' )
    mkdir -p ${Dir_Session} ${Dir_Watch}


			## Mindenképp törlöm a lock file-t mivel ha van akkor nem fog elindulni
    Lock_File=${Dir_Session}/rtorrent.lock
    [ -e ${Lock_File} ] && rm ${Lock_File}

	# Jól álljanak a jogosultságok
    chown -Rc abc:abc 	/config
    chown -Rc abc 	/downloads


    umask $UMASK 			# Csak ha van UMASK, különben csak kiírja

    export TERM="xterm"
    export HOME="/config"
    export PWD="/config"
    cd /config

    exec chpst -u abc:abc /usr/bin/rtorrent -n -o import=/config/rtorrent.rc

##   exec chpst -u abc:abc /usr/bin/screen -Dmfa -S rtorrent /usr/bin/rtorrent -n -o import=/config/rtorrent.rc
