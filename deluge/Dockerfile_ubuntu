FROM ubuntu:18.04

LABEL 	maintainer="Volarics István volaricsi@volarics.hu" 		\
	url="https://github.com/VolaricsI/docker-image"

ENV ImageNeve="deluge"

	## Személyre szabott beállítások
ENV PUID=2002 PGID=2002 UMASK=002 TIME_ZONE=Europe/Budapest PLUGIN_DISABLE=default

	## Kell az apt-utils, hogy ne legyenek hibaüzenetek
RUN export DEBIAN_FRONTEND=noninteractive &&  apt-get update -y && apt-get install -y apt-utils && apt-get upgrade -y 	\
	## Install required packages.: a runit-ből csak a chpst kell;
    && apt-get install -y runit tzdata && cp $( find / -iname chpst ) /usr/sbin/chpst 			\
    && ln -nf /usr/share/zoneinfo/${TIME_ZONE} /etc/localtime && echo "${TIME_ZONE}" >/etc/timezone 	\
    && apt-get remove --purge -y runit tzdata 		\
	## Ez fog futni; illetve az alap config-ot gyártom le vele
    && apt-get install -y deluged deluge-console 	\
	## Ezek feleslegesek
    && apt-get remove --purge -y bzip2 xz-utils 	\
    && apt-get autoremove --purge -y && apt-get clean 	\
##    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* 	\
    && mkdir -p /defaults /config /downloads

COPY defaults /defaults

RUN /defaults/config.sh && /defaults/config-deluge.sh && /defaults/config-munin.sh

## dht; data ports; Admin/távirányító/management port
EXPOSE 6881/udp 6881 58846

## Konfigok helye; ide kerülnek a letöltések
VOLUME /config /downloads

CMD ["/start.sh"]
