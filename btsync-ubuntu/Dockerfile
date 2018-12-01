# Sets up a Resilio server with management ports.

FROM ubuntu
MAINTAINER Volarics István volaricsi@gmail.com

# Kell a start.sh-nak mivel innen tudja, hogy más programok kezelit a felhasználókat.
ENV ALAP=ubuntu

# Install required packages.: sgrep, chpst program, and resilio
RUN apt update && apt upgrade -y 	\
    && apt install -y wget runit && cp /usr/bin/chpst /bin/chpst 	\
    && cd /tmp && wget --quiet https://download-cdn.resilio.com/stable/linux-x64/resilio-sync_x64.tar.gz 	\
    && tar xvzf resilio-sync_x64.tar.gz && cp rslsync /usr/bin/ 	\
    && apt remove --purge -y wget runit && apt autoremove --purge -y && apt clean 	\
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* 	\
    && mkdir -p /defaults /config /downloads

COPY defaults /defaults

# Add the start script. Create example config
RUN cd /defaults/ && chmod +x * && mv start.sh / && cp verzio create_default_config /usr/bin/

# Expose the deluge control port and data port.
EXPOSE 55555 8888

# Setup volumes.
VOLUME /config /downloads

# Run the start script on boot.
CMD ["/start.sh"]
