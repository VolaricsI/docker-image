#!/bin/sh
#
#	Create by Voli

DIR_RUT=/var/www/ruTorrent

    rm -rf ${DIR_RUT}/.git* 					## Forrásból esetén nem kell a git tároló adatbázisa

# Hogy a beállítások megmaradjanak; és legyen ahonnan fel tud emelni torrenteket
    rm -rf ${DIR_RUT}/share/settings ${DIR_RUT}/share/torrents && mkdir -p /config/rutorrent_settings /config/watched 	\
    && ln -s /config/rutorrent_settings ${DIR_RUT}/share/settings 	\
    && ln -s /config/watched  ${DIR_RUT}/share/torrents 	\
    || exit 32

    Php=$( which php ) 		## Kell az egyik plugin-nek
				## Menjen az error a std-re, mert onnan kiolvasható
    sed -i 	"s|\"php\".*=>.*''|\"php\" => '${Php}'| 	\
		;s|/tmp/errors.log|/dev/stdout| " 		${DIR_RUT}/conf/config.php 	\
    || exit 33

# a plugin-ek kezelése: ini file megörzése; link gyártás
    cp ${DIR_RUT}/conf/plugins.ini /defaults/ 	\
    && mv ${DIR_RUT}/conf/plugins.ini /config/rutorrent_settings && ln -s /config/rutorrent_settings/plugins.ini ${DIR_RUT}/conf/plugins.ini 	\
    && chown -RL abc:abc /defaults /var/www 	\
    || exit 34

    plugins_disable default ${PLUGIN_DISABLE} 		##

    chown -R abc:abc /var/www

exit 0
