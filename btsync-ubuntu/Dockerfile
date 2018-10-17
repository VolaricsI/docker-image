# Sets up a Resilio server with management ports.

FROM ubuntu
MAINTAINER Volarics István volaricsi@gmail.com

# Install required packages.: sgrep, chpst program, and resilio
RUN apt update && apt upgrade -y && 	\
    apt install -y sgrep wget runit && cp /usr/bin/chpst /bin/chpst && 	\
    cd /tmp && wget --quiet https://download-cdn.resilio.com/stable/linux-x64/resilio-sync_x64.tar.gz && 	\
    tar xvzf resilio-sync_x64.tar.gz && cp rslsync /bin/rslsync && 	\
    apt remove --purge -y runit  wget && apt autoremove --purge -y && apt clean && 	\
    mkdir -p /defaults && mkdir -p /config && mkdir -p /downloads

# Clean up.
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY defaults /defaults

# Add the start script. Create example config
RUN mv /defaults/start.sh /start.sh && 	\
    cd /tmp/ && rslsync --dump-sample-config | grep -v "/\*.*\*/"| \
    sed 's/\/\/ \"listening_port\" : .*/\"listening_port\" : 55555 ,/g; \
	 s/\/\/ \"storage_path\" .*/\"storage_path\" : \"\/config" ,/g; \
	 s/\/\/  \"directory_root\" : .*/\"directory_root\" : \"\/downloads\" ,/g; ' 	\
    |sgrep  -a -o "" '"/*" quote "*/"'  |grep -v "^//"	>/defaults/sync.conf.example


# Expose the deluge control port and data port.
EXPOSE 55555 8888

# Setup volumes.
VOLUME /config /downloads

# Run the start script on boot.
CMD ["/start.sh"]
