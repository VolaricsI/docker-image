#!/bin/sh
#
#	Create by Voli

    rm -rf /var/www/html /var/www/localhost

    rm -rf ${DIR_RUT}/.git* ${DIR_RUT}/share/.htaccess ${DIR_RUT}/share/users/.gitignore		## Nem kell a git és a többi

    mv ${DIR_RUT}/js/webui.js /app/webui.js 		## A $TITLE változó a /app könyvtárba készüljön a változtatás (szebb)
    ln -s /app/webui.js ${DIR_RUT}/js/webui.js

		## Hogy a beállítások megmaradjanak, és legyen ahonnan fel tud emelni torrenteket
    mkdir -p /config/rutorrent_settings && rm -rf ${DIR_RUT}/share/settings && ln -s /config/rutorrent_settings	${DIR_RUT}/share/settings	||exit 20
    mkdir -p /config/watched            && rm -rf ${DIR_RUT}/share/torrents && ln -s /config/watched 		${DIR_RUT}/share/torrents	||exit 21

		## a plugin.ini kezelése: ini file megörzése; link gyártás
    cp ${DIR_RUT}/conf/plugins.ini /defaults/plugins.ini			||exit 30
    mv ${DIR_RUT}/conf/plugins.ini /config/rutorrent_settings			||exit 31
    ln -s /config/rutorrent_settings/plugins.ini ${DIR_RUT}/conf/plugins.ini	||exit 32

################################## Egyedileg kezelt PlugIn-ek
		## Menjen az error a std-re, mert onnan kiolvasható
    Php=$( which php ) 		## Kell az egyik plugin-nek
    sed -i "s|\"php\".*=>.*''|\"php\" => '${Php}'|; s|/tmp/errors.log|/dev/console| " ${DIR_RUT}/conf/config.php 	||exit 50

		## _task
    sed -i  "s| = '';| = '/usr/bin/pgrep';|" ${DIR_RUT}/plugins/_task/conf.php		||exit 51

		## unrar
	# Ha nincs meg a program akkor tiltás:
	# rm -rf  {DIR_RUT}/plugins/unpack
    cd /tmp
    wget https://www.rarlab.com/rar/rarlinux-x64-711.tar.gz 	\
    && tar xf /tmp/rarlinux-x64-711.tar.gz 			\
    && cp rar/unrar /bin && rm -rf /tmp/rar rarlinux-x64-711.tar.gz				||exit 52

		## dumptorrent a szükséges program nincs csomagban és nem is tölthető le a binárisa
    rm -rf ${DIR_RUT}/plugins/dump								||exit 53

		## _cloudflare Olyan python modul kell ami nem elérhető Alpine alatt
    rm -rf ${DIR_RUT}/plugins/_cloudflare							||exit 54

    chmod -RLc 775 ${DIR_RUT}/share

    chown -RLc abc:abc	/var/www 								||exit 60
#    find /var/www ! \( -user abc -a -group abc \) -exec chown -Lc abc:abc {} + 			||exit 60

exit 0
