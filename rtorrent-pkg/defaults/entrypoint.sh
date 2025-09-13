#!/bin/sh
#
#	Create by Voli

    /defaults/adduser-abc || exit 1		## Ha kell akkor ujra alkotjuk az abc felhasználót

####################################################	## Csak akkor fusson ha VALÓBAN a megfelelő könyvtár van alatta
    if [ .$( cat /downloads/.docker-mount-point ) != ./downloads ]; then
	echo "Nem megfelelő a csatolt könyvtár...."
	exit 2
    fi

#################################################### /app könyvtár KÍVÜLRŐL tmpfs-re lett rakva akkor üres és így feltöltöm
    [ ! -e /app/webui.js ] && cp -a /defaults/app /

#################################################### ruTorrent
	##Ha meg van adva, akkor ez lesz a web-es felület fejléce (title)
    [ -n "${TITLE}" ] && sed -i "s/\(newTitle+=\"\).*+self.version;/\1${TITLE}\";/" /app/webui.js
	## Hogy a beállítások megmaradjanak, és legyen ahonnan fel tud emelni torrenteket
    mkdir -p /config/rutorrent_settings /config/watched
	## a plugin.ini kezeléseini
    [ ! -e /config/rutorrent_settings/plugins.ini ] && cp /defaults/plugins.ini /config/rutorrent_settings/plugins.ini
	## Az RSS plugin-nak kell, -c nem lehet mivel ez a /config-ba van linkelve és itt a változtatás ne jelenjen meg a logban
    chmod -R 775 /var/www/ruTorrent/share

#################################################### php-fpm
    if [ ! -e /config/php-fpm.conf ]; then
	cp /defaults/php-fpm.conf.* 	  /config/
	cp /defaults/php-fpm.conf.example /config/php-fpm.conf
    fi

#################################################### nginx
    if [ ! -e /config/nginx.conf ]; then
	cp /defaults/nginx.conf.example /config/
	cp /defaults/nginx.conf.example /config/nginx.conf
    fi

#################################################### rtorrent
    [ ! -e /config/session ] && mkdir -p /config/session
	## Konfig ha nincs
    if [ ! -e /config/rtorrent.rc ]; then
	cp /defaults/rtorrent.rc* 	 /config/
	cp /defaults/rtorrent.rc.example /config/rtorrent.rc
    fi

	## Ha van lock file akkor nem indul el
    LockFile=$( find /config -name rtorrent.lock )
    [ -n "$LockFile" ] && [ -e "$LockFile" ] && rm $LockFile

	## Jogosultság beállítása
    [ -e /dev/console ] && chown abc:abc /dev/console	2>&1 >/dev/null
    find /config /var/www 	! \( -user abc -a -group abc \) -exec chown -Lc abc:abc {} +
#    find /downloads		! \( -user abc               \) -exec chown -Lc abc:    {} +

    exec $@
