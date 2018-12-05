FROM ubuntu
MAINTAINER Volarics István volaricsi@gmail.com


RUN export DEBIAN_FRONTEND=noninteractive 	\
    && echo "Ezen programok kellenek" 	\
	&& apt update && apt -y upgrade && apt install -y rtorrent screen nginx php-fpm runit 	\
    && echo "A Szükséges könyvtárak" 	\
	&& mkdir -p /defaults /config /downloads 	\
    && echo "A ruTorrent és egy kis pach hogy a pluginek lássák a curl-t..." 	\
	&& apt install -y curl git 	\
	&& cd /var/www && git clone https://github.com/Novik/ruTorrent.git && rm -rf /var/www/ruTorrent/.git 	\
	&& sed -i "s/\("curl".*=> \)''/\1'\/usr\/bin\/curl'/g; " /var/www/ruTorrent/conf/config.php 	\
	&& chown -R www-data:www-data /var/www 	\
    && echo "Ideiglenesen kellet programok eltávolítása" 	\
	&& apt remove --purge -y git && apt autoremove --purge -y

COPY defaults /defaults

RUN mv /defaults/start.sh / && cp /defaults/verzio /defaults/disable_plugins /defaults/ellenorzes /usr/bin/ 	\
    && echo "A runit inditok legyartasa es a szükséges beáálítások; ne legyen hibaüzenet..." 	\
	&& mkdir -p /etc/runit/runsvdir/default/nginx 		&& mv /defaults/run_nginx    /etc/runit/runsvdir/default/nginx/run 	&& chmod +x /etc/runit/runsvdir/default/nginx/run 	\
	&& mkdir -p /etc/runit/runsvdir/default/php-fpm 	&& mv /defaults/run_php-fpm  /etc/runit/runsvdir/default/php-fpm/run 	&& chmod +x /etc/runit/runsvdir/default/php-fpm/run 	\
	&& mkdir -p /etc/runit/runsvdir/default/rtorrent 	&& mv /defaults/run_rtorrent /etc/runit/runsvdir/default/rtorrent/run 	&& chmod +x /etc/runit/runsvdir/default/rtorrent/run 	\
	&& touch    /etc/init.d/rcS /etc/init.d/rmnologin /etc/init.d/rc && chmod +x /etc/init.d/rcS /etc/init.d/rmnologin /etc/init.d/rc 	\
    && echo "A nginx configja..." 	\
	&& rm -f /etc/nginx/sites-enabled/default && mv /defaults/nginx_rutorrent_minimal.conf /etc/nginx/sites-enabled/ 	\
	&& sed -i 's/\(worker_processes\) auto;/\1 2;/g; s/\(access_log\) .\+;/\1 \/proc\/1\/fd\/1;/g; s/\(error_log\) .\+;/\1 \/proc\/1\/fd\/1;/g ' /etc/nginx/nginx.conf 	\
    && echo "A php-fpm beallitasa az error log átírányítva a konzolra..." 	\
	&& cd /etc/php/7.2/fpm && cp php-fpm.conf php-fpm.conf.orig && sed -i 's/\(error_log = \).*$/\1 \/proc\/1\/fd\/1/g; ' php-fpm.conf 	\
    && echo "Az rtorrent plugins configurálása..." 	\
	&& cp /var/www/ruTorrent/conf/plugins.ini /var/www/ruTorrent/conf/plugins.ini.orig && disable_plugins default

#Ez csak akkor kell ha pluginokat is akarsz használni...
#RUN apt install -y sox unzip unrar mediainfo ffmpeg

# Csak az xmlrpc programra van szükségem
RUN apt install -y libxmlrpc-core-c3-dev && cp /usr/bin/xmlrpc /usr/local/bin && apt remove --purge -y libxmlrpc-core-c3-dev

## Takarítás, ami várhatóan meg kell
RUN apt remove --purge -y manpages manpages-dev openssl publicsuffix xz-utils geoip-database bzip2 krb5-locales 	\
    && apt autoremove --purge -y && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && rm -rf /var/cache

# Expose the WebUI control port and data ports.
EXPOSE 80 6881/udp 51413

# Setup volumes.
VOLUME /config /downloads

# Run the start script on boot.
CMD ["/start.sh"]
