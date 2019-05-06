#!/bin/sh
#
#	Create by Voli

CONF=/config/sync.conf

    cd /tmp

    /defaults/adduser-abc || exit 1

if [ ! -f ${CONF}  ]; then 				## Ha nincs konfig akkor kap egy alapértelmezettet
    echo "Doing initial setup."

    rslsync --dump-sample-config | grep -v "/\*.*\*/" 			>$CONF

    sed -i 's/.*listening_port\".*/\"listening_port\" : 55555 ,/g; ' 			$CONF
    sed -i 's/.*storage_path\".*/\"storage_path\" : \"\/config" ,/g; ' 			$CONF
    sed -i 's/.*directory_root\".*:.*/\"directory_root\" : \"\/downloads\" ,/g; ' 	$CONF
    sed -i 's/.*pid_file\".*/\"pid_file\" : \"\/config\/resilio.pid",/g; ' 		$CONF
    cp ${CONF} ${CONF}.example

    rm -rf /tmp/.sync /tmp/resilio_dumps
fi

    chown -R abc:abc 	/config
    chown    abc 	/downloads

    umask $UMASK

    echo "Starting resilio..."
    exec chpst -u abc:abc /usr/bin/rslsync --nodaemon --config ${CONF}
