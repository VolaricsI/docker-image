#!/bin/sh
#
#	Create by Voli

    adduser-abc

if [ ! -f /config/sync.conf  ]; then				## Ha nincs konfig akkor kap egy alapértelmezettet
        echo "Doing initial setup."
	cd /config
	create_default_config >sync.conf.example
	cp sync.conf.example sync.conf
fi

    chown -R abc:abc 	/config
    chown    abc 	/downloads

    echo "Starting resilio..."
    cd /tmp
    /usr/bin/rslsync --help |grep "Resilio Sync"		## a verzio kiíratás miatt
    rm -rf /tmp/.sync

    umask $UMASK

    exec chpst -u abc /usr/bin/rslsync --nodaemon --config /config/sync.conf
