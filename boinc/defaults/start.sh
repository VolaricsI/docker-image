#!/bin/sh
#
#	Create by Voli

    /defaults/adduser-abc || exit 1

    chown -R abc:abc 	/config

    echo "Starting boinc..."
    cd /config
    exec chpst -u abc:abc /usr/bin/boinc --dir /config
