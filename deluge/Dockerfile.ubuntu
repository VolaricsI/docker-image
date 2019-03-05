# Sets up a Deluge server with management ports.

FROM ubuntu
MAINTAINER Volarics István volaricsi@gmail.com
				##Inspirált: jordancrawford/rpi-deluge >>> Jordan Crawford <jordan@crawford.kiwi>

# Kell a start.sh-nak mivel innen tudja, hogy más programok kezelit a felhasználókat.
ENV ALAP=ubuntu

ENV TIME_ZONE=Europe/Budapest

# Install required packages.: deluged, deluge-console and chpst program
RUN apt update && apt install -y software-properties-common && add-apt-repository -y ppa:deluge-team/ppa && apt update -y 	\
    && apt install -y deluged deluge-console 	\
    && apt install runit tzdata && cp /usr/bin/chpst /bin/chpst 	\
    && ln -nf /usr/share/zoneinfo/$TIME_ZONE /etc/localtime && echo $TIME_ZONE >/etc/timezone 	\
    && apt remove --purge -y software-properties-common runit tzdata && apt autoremove --purge -y && apt clean 	\
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* 	\
    && mkdir -p /defaults && mkdir -p /config && mkdir -p /downloads

COPY defaults /defaults

RUN chmod +x /defaults/* && mv /defaults/start.sh /start.sh && mv /defaults/verzio /defaults/adduser-abc /usr/bin/ && echo "$PUID-----$PGUI!!!!!"

# Expose the deluge control port and data port.
EXPOSE 58846 6881 6881/udp

# Setup volumes.
VOLUME /config /downloads

# Run the start script on boot.
CMD ["/start.sh"]
