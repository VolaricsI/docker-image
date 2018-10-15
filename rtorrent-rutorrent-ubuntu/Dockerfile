FROM ubuntu
MAINTAINER Volarics István volaricsi@gmail.com

					## Ezen programok kellenek; 	Ideiglenesen; 	A szükséges Könyvtárak

RUN export DEBIAN_FRONTEND=noninteractive && 	\
    apt update && apt -y upgrade && apt install -y rtorrent screen nginx php-fpm runit libxmlrpc-core-c3-dev curl git && 	\
    mkdir -p /defaults && mkdir -p /config && mkdir -p /downloads && mkdir -p /run/php && 	\
    echo "A ruTorrent és egy kis pach hogy a pluginek lássák a curl-t..." && 	\
    cd /var/www && git clone https://github.com/Novik/ruTorrent.git && chown -R www-data:www-data /var/www && 	\
    cd /var/www/ruTorrent/conf && mv config.php config.php.1 && sed "s/\("curl".*=> \)''/\1'\/usr\/bin\/curl'/g; " config.php.1 >config.php && rm config.php.1

COPY defaults /defaults

RUN 	mv /defaults/start.sh / && 	\
    echo "A runit inditok legyartasa es a szükséges beáálítások, hogy ne legyen hibaüzenet....." && 	\
	mkdir -p /etc/runit/runsvdir/default/nginx 	&& mv /defaults/run_nginx    /etc/runit/runsvdir/default/nginx/run 	&& chmod +x /etc/runit/runsvdir/default/nginx/run 	&& 	\
	mkdir -p /etc/runit/runsvdir/default/php-fpm 	&& mv /defaults/run_php-fpm  /etc/runit/runsvdir/default/php-fpm/run 	&& chmod +x /etc/runit/runsvdir/default/php-fpm/run 	&& 	\
	mkdir -p /etc/runit/runsvdir/default/rtorrent 	&& mv /defaults/run_rtorrent /etc/runit/runsvdir/default/rtorrent/run 	&& chmod +x /etc/runit/runsvdir/default/rtorrent/run 	&& 	\
	touch /etc/init.d/rcS && chmod +x /etc/init.d/rcS && touch /etc/init.d/rmnologin && chmod +x /etc/init.d/rmnologin && touch /etc/init.d/rc && chmod +x /etc/init.d/rc && 	\
    echo "A nginx configja....." && \
	rm -f /etc/nginx/sites-enabled/default && mv /defaults/nginx_rutorrent_minimal.conf /etc/nginx/sites-enabled/ && 	\
	cd /etc/nginx/ && mv nginx.conf nginx.conf.orig && 	\
	sed 's/\(worker_processes\) auto;/\1 2;/g; s/\(access_log\) .\+;/\1 \/proc\/1\/fd\/1;/g; s/\(error_log\) .\+;/\1 \/proc\/1\/fd\/1;/g ' nginx.conf.orig >nginx.conf &&	\
    echo "A php-fpm beallitasa az error log átírányítva a konzolra..." && \
	cd /etc/php/7.2/fpm && mv php-fpm.conf php-fpm.conf.orig && sed 's/\(error_log = \).*$/\1 \/proc\/1\/fd\/1/g; ' php-fpm.conf.orig >php-fpm.conf && \
    echo "Az rtorrent plugins configurálása...." && \
	cp /var/www/ruTorrent/conf/plugins.ini /var/www/ruTorrent/conf/plugins.ini.orig && /defaults/disable_plugins hibas && 	\
    echo "A felesleg eltavolitasa...."

#Ez csak akkor kell ha pluginokat is akarsz használni...
#RUN apt install -y sox unzip unrar mediainfo ffmpeg

## Takarítás
RUN apt remove --purge -y git && apt autoremove --purge -y && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && rm -rf /var/cache

# Expose the WebUI control port and data ports.
EXPOSE 80 6881/udp 51413

# Setup volumes.
VOLUME /config /downloads

# Run the start script on boot.
CMD ["/start.sh"]
