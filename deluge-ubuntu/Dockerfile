# Sets up a Deluge server with management ports.

FROM ubuntu
MAINTAINER Volarics István volaricsi@gmail.com
				##Inspirált: jordancrawford/rpi-deluge >>> Jordan Crawford <jordan@crawford.kiwi>

# Install required packages.: deluged, deluge-console and chpst program
RUN apt update && apt install -y software-properties-common && add-apt-repository -y ppa:deluge-team/ppa && apt update -y && 	\
    apt install -y deluged deluge-console && 	\
    apt install runit && cp /usr/bin/chpst /bin/chpst && 	\
    apt remove --purge -y software-properties-common runit && apt autoremove --purge -y && apt clean && 	\
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && 	\
    mkdir -p /defaults && mkdir -p /config && mkdir -p /downloads

COPY defaults /defaults

RUN mv /defaults/start.sh /start.sh && chmod +x /start.sh

# Expose the deluge control port and data port.
EXPOSE 58846 6881 6881/udp

# Setup volumes.
VOLUME /config /downloads

# Run the start script on boot.
CMD ["/start.sh"]
