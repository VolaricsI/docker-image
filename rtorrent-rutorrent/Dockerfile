FROM alpine

		##Ezek a programok kellenek még a plugin-eknek ha szükségét érzed
#ENV PLUGIN_PRG=" ffmpeg sox mediainfo unrar "
		## Ekkor a csomagban léző rutorrent-et teszi fel és nem a github-os verziót
#ENV RUTORRENT_PKG=" rutorrent "

ENV TIME_ZONE=Europe/Budapest


		# A szükséges programok; runit-ből csak a chpst kell; A végén törlöm ami már nem kell; ffmpeg-től a plugin-eknek kellenek
RUN apk update && apk upgrade 	\
	# A futtató környezet
    && apk add --no-cache supervisor rtorrent php7 php7-fpm php7-json nginx curl $PLUGIN_PRG $RUTORRENT_PKG 	\
	# Csak a telepítéshez kell
    && apk add --no-cache git runit tzdata && cp /sbin/chpst /usr/sbin/chpst 	\
	# ruTorrent telepítése vagy forrásból vagy csomagból
    && mkdir -p /var/www && cd /var/www 	\
    && if [ ".$RUTORRENT_PKG" == "." ]; then git clone https://github.com/Novik/ruTorrent.git; rm -rf /var/www/ruTorrent/.git; fi 	\
    && if [ ".$RUTORRENT_PKG" != "." ]; then ln -s /usr/share/webapps/rutorrent /var/www/ruTorrent; fi 	\
    && rm -rf /var/www/ruTorrent/share/settings && mkdir -p /config/rutorrent_settings && ln -s /config/rutorrent_settings /var/www/ruTorrent/share/settings 	\
    && chown -RL nginx:www-data /var/www/ 	\
    && if [ ".$TIME_ZONE" != "." ]; then ln -nf /usr/share/zoneinfo/$TIME_ZONE /etc/localtime; echo $TIME_ZONE >/etc/timezone; fi 	\
	# ami már nem kell
    && apk del git runit tzdata 	\
	# Az alap könyvtárak
    && mkdir -p /defaults /config /downloads

#    mkdir -p /run/nginx /run/php /var/log/nginx && 	\

COPY defaults /defaults

		# Konfig file-ok elhelyezése;  ; a disable_plugins-hoz + alap plugin beállítás
RUN mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.orig && mv /defaults/nginx.conf /etc/nginx/nginx.conf 	\
    && mkdir -p /etc/nginx/sites-enabled && cp /defaults/nginx-rutorrent.conf /etc/nginx/sites-enabled/ 	\
	# php-fpm configja
    && rm /etc/php7/php-fpm.d/* && mv /defaults/php-fpm-rutorrent.conf /etc/php7/php-fpm.d/ 	\
    && sed -i 's/.*error_log =.*/error_log = \/proc\/1\/fd\/1/g; ' /etc/php7/php-fpm.conf 	\
	# a rutorrent lássa a curl-t + a log nem kell
    && sed -i "s/\("curl".*=> \)''/\1'\/usr\/bin\/curl'/g; " /var/www/ruTorrent/conf/config.php 	\
    && sed -i 's/\(.*$log_file = .*\)/\/\/\1/g; ' /var/www/ruTorrent/conf/config.php 	\
	# a plugin-ek engedélyezése
    && cp /var/www/ruTorrent/conf/plugins.ini /defaults/ && if [ ".$PLUGIN_PRG" == "." ]; then /defaults/disable_plugins minimal; fi 	\
	# A supervisord beállítása
    && mkdir -p /etc/supervisor.d && mv /defaults/supervisord.ini /etc/supervisor.d/ && mv /defaults/start.sh /


## WebAdmin, dht, data ports; ha kell akkor az rtorrent xmlrpc távirányító portja
EXPOSE 80 6881/udp 51413 5000

## Konfigok helye; ide kerülnek a letöltések
VOLUME /config /downloads

CMD ["/start.sh"]
