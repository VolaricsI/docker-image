############## build stage ##############
FROM alpine as buildstage

#A git-tel erre a verzióra kell állni
ARG VER_LIBTORRENT=libtorrent-1_1_9
ARG VER_QBITTORRENT=v4_1_x

	# **** A fordításhoz ezek a csomagok kellenek ****
RUN apk add --no-cache --virtual=build-dependencies autoconf automake boost-dev cmake curl file g++ geoip-dev git libtool make qt5-qttools-dev

	# **** libtorrent forditasa *****
RUN cd /tmp && git clone https://github.com/arvidn/libtorrent.git && cd libtorrent && git checkout "$VER_LIBTORRENT" 	\
    && ./autotool.sh && ./configure --disable-debug --enable-encryption --prefix=/usr && make &&  make DESTDIR=/tmp/rasterbar-build install 	\
    && strip --strip-unneeded /tmp/rasterbar-build/usr/lib/libtorrent-rasterbar.so* /tmp/rasterbar-build/usr/lib/libtorrent-rasterbar.a* 	\
    && cp -pr /tmp/rasterbar-build/usr/* /usr/

	# **** qBittorrent forditasa ****
RUN cd /tmp && git clone https://github.com/qbittorrent/qBittorrent.git && cd qBittorrent && git checkout "$VER_QBITTORRENT" 	\
    && ./configure --disable-gui --prefix=/usr && make && make INSTALL_ROOT=/tmp/qbittorrent-build install


############## runtime stage ##############
FROM alpine

MAINTAINER Volarics István <volaricsi@volarics.hu>
LABEL maintainer="Volarics István <volaricsi@volarics.hu>"
LABEL build_version="version: $VER_QBITTORRENT/$VER_LIBTORRENT"
LABEL build_date="Build-date: ${BUILD_DATE}"

	# **** install runtime packages ****
RUN apk add --no-cache qt5-qtbase boost-system curl 	\
    && apk add runit && cp /sbin/chpst /bin/chpst && apk del runit 	\
    && mkdir /defaults /config /downloads && ln -s /config /qBittorrent

COPY --from=buildstage /tmp/qbittorrent-build/usr/ /usr/
COPY --from=buildstage /tmp/rasterbar-build/usr/   /usr/
COPY defaults /defaults

RUN cd /defaults && mv start.sh / && cp healtcheck verzio /usr/bin/ && chmod +x /start.sh /usr/bin/healtcheck /usr/bin/verzio

# ports and volumes; a 8080 átírható WEBUI_PORT változóval
EXPOSE 6881 6881/udp 8080
VOLUME /config /downloads

# Run the start script on boot.
CMD ["/start.sh"]

# Health check
#HEALTHCHECK CMD healtcheck
