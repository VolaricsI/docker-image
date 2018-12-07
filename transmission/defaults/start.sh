#!/bin/sh

    adduser-abc

if [ ! -e /config/settings.json ]; then	## Ha nincs konfig kap egy alapot
    echo "Ceating default/minimal configure file..."
    transmission-daemon --dump-settings 		2>/config/settings.json

    sed -i 's/\/root\/Downloads/\/downloads/g ' 						/config/settings.json 	# Minden letöltés ide
    sed -i 's/"umask": 18,/"umask": 2,/ ' 							/config/settings.json

    sed -i 's/"lpd-enabled": false,/"lpd-enabled": true,/ ' 					/config/settings.json

    sed -i 's/"rpc-whitelist-enabled": true,/"rpc-whitelist-enabled": false,/ ' 		/config/settings.json 	# A management működjön
    sed -i 's/"rpc-host-whitelist-enabled": true,/"rpc-host-whitelist-enabled": false,/ ' 	/config/settings.json

    sed -i 's/"utp-enabled": true/"utp-enabled": true,/ ' 					/config/settings.json	# Nem vele van vége
    sed -i 's/^}/"watch-dir": "\/config\/watch",\n"watch-dir-enabled": true\n}/ ' 		/config/settings.json	# Így lesz "watch" dir

fi

    WatchDir=$( cat /config/settings.json |grep \"watch-dir\":|sed 's/.*"\//\//g; s/".*//g' )

    [ ! -e ${WatchDir} ] && mkdir ${WatchDir}

echo "Setting owner for config and data directories."
    chown -R abc:abc 	/config
    chown    abc 	/downloads

echo "Starting transmission..."
    exec chpst -u abc:abc /usr/bin/transmission-daemon -g /config -c /config/watch -f
