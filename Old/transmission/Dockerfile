FROM alpine

MAINTAINER Volarics István <volaricsi@volarics.hu>
LABEL maintainer="Volarics István <volaricsi@volarics.hu>"
LABEL build_date="Build-date: ${BUILD_DATE}"

	# **** install packages ****
RUN apk add --no-cache transmission-daemon 	\
    && apk add runit && cp /sbin/chpst /bin/chpst && apk del runit 	\
    && mkdir -p /defaults /downloads

COPY defaults /defaults

RUN cd /defaults && chmod +x * && mv start.sh / && cp healtcheck verzio adduser-abc /usr/bin/

# ports and volumes;
EXPOSE 51413 51413/udp 9091
VOLUME /config /downloads

# Run the start script on boot.
CMD ["/start.sh"]

# Health check
#HEALTHCHECK CMD healtcheck
