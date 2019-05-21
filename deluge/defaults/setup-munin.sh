#!/bin/sh
#
#	Create by Voli

    export username=$( cat /config/auth|grep localclient|cut -d: -f1 )
    export password=$( cat /config/auth|grep localclient|cut -d: -f2 )

    sed -i "s/os.getenv('username', '.*')/os.getenv('username', '$username')/g" 	/defaults/munin/deluge_
    sed -i "s/os.getenv('password', '.*')/os.getenv('password', '$password')/g" 	/defaults/munin/deluge_
