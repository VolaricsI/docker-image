#!/bin/sh

    CONF_FILE=/etc/lighttpd/lighttpd.conf

    [ -e /config/lighttpd.conf ] && CONF_FILE=" /config/lighttpd.conf "

	# Ezek a könyvtárak a rutorrent-hez kell
    mkdir -p /config/rutorrent_settings /config/rutorrent_watched && chown -RL abc:abc 	/config

	# A plugin-ek beállítása
    [ ! -z "${PLUGIN_DISABLE}" ] && plugins_disable ${PLUGIN_DISABLE}

exec lighttpd -D -f ${CONF_FILE}
