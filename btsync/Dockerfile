# Sets up a Resilio server with management ports.

FROM frolvlad/alpine-glibc
MAINTAINER Volarics István volaricsi@gmail.com

# Install required packages.: a runit-ből csak a chpst kell; shadow a felhasználó létrehozáshoz; resilio
RUN apk update && apk upgrade && 	\
    apk add runit && cp /sbin/chpst /usr/bin/ && apk del runit && 	\
    cd /tmp && wget --quiet https://download-cdn.resilio.com/stable/linux-x64/resilio-sync_x64.tar.gz && 	\
    tar xvzf resilio-sync_x64.tar.gz && cp rslsync /usr/bin/ && 	\
    mkdir -p /defaults /config /downloads

COPY defaults /defaults

# Add the start script. Create example config
RUN mv /defaults/start.sh /start.sh && chmod +x /start.sh && 	\
    cd /tmp/ && rslsync --dump-sample-config | grep -v "/\*.*\*/"| \
    sed 's/\/\/ \"listening_port\" : .*/\"listening_port\" : 55555 ,/g; \
	 s/\/\/ \"storage_path\" .*/\"storage_path\" : \"\/config" ,/g; \
	 s/\/\/  \"directory_root\" : .*/\"directory_root\" : \"\/downloads\" ,/g; ' 	\
    |grep -v "^//"	>/defaults/sync.conf.example && 	\
    rm -rf /tmp/.sync /tmp/*


# Expose the deluge control port and data port.
EXPOSE 55555 8888

# Setup volumes.
VOLUME /config /downloads

# Run the start script on boot.
CMD ["/start.sh"]
