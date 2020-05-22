#!/bin/sh
#
#	Create by Voli

PLUGIN=/defaults/munin/deluge_

    export username=$( cat /config/auth|grep localclient|cut -d: -f1 )
    export password=$( cat /config/auth|grep localclient|cut -d: -f2 )

    sed -i "s/os.getenv('username', '.*')/os.getenv('username', '$username')/g" 	${PLUGIN}
    sed -i "s/os.getenv('password', '.*')/os.getenv('password', '$password')/g" 	${PLUGIN}

    [ ! -z ${MUNIN_category} ] && sed -i "s/print(\"graph_category .*\")/print(\"graph_category ${MUNIN_category}\")/g "		${PLUGIN}
    if [ ! -z ${MUNIN_tittle} ]; then
	sed -i "s/print(\"graph_title .*Number of connections\")/print(\"graph_title ${MUNIN_tittle} Number of connections\")/g " 	${PLUGIN}
	sed -i "s/print(\"graph_title .*Bandwidth usage\")/print(\"graph_title ${MUNIN_tittle} Bandwidth usage\")/g " 			${PLUGIN}
	sed -i "s/print(\"graph_title .*Torrents states\")/print(\"graph_title ${MUNIN_tittle} Torrents states\")/g " 			${PLUGIN}
    fi
