# Sets up a Resilio server with management ports.

FROM frolvlad/alpine-glibc
MAINTAINER Volarics István volaricsi@gmail.com

ENV TIME_ZONE=Europe/Budapest

# Install required packages.: a runit-ből csak a chpst kell; resilio
RUN apk update && apk upgrade 	\
    && apk add runit tzdata && cp /sbin/chpst /usr/bin/ 	\
    && ln -nf /usr/share/zoneinfo/$TIME_ZONE /etc/localtime && echo $TIME_ZONE >/etc/timezone 	\
    && apk del runit tzdata 	\
    && cd /tmp && wget --quiet https://download-cdn.resilio.com/stable/linux-x64/resilio-sync_x64.tar.gz 	\
    && tar xvzf resilio-sync_x64.tar.gz && cp rslsync /usr/bin/ 	\
    && rm -rf /tmp/* 	\
    && mkdir -p /defaults /config /downloads

COPY defaults /defaults

# Add the start script. Create example config
RUN cd /defaults/ && chmod +x * && mv start.sh / && mv * /usr/bin/ && adduser-abc

# Expose the deluge control port and data port.
EXPOSE 55555 8888

# Setup volumes.
VOLUME /config /downloads

# Run the start script on boot.
CMD ["/start.sh"]
