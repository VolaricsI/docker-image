FROM alpine:edge

RUN apk update && apk upgrade 	\
    && apk add runit && cp /sbin/chpst /bin/chpst && apk del runit 	\
    && apk add openssl 	\
    && apk add --no-cache --repository http://nl.alpinelinux.org/alpine/edge/testing deluge

COPY defaults /defaults

RUN mv /defaults/start.sh /start.sh && chmod +x /start.sh

# Expose the deluge control port and data port.
EXPOSE 58846 6881 6881/udp

# Setup volumes.
VOLUME /config /downloads

# Run the start script on boot.
CMD ["/start.sh"]
