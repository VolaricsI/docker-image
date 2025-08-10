#!/bin/sh
#
#	Create by Voli

#!/bin/sh
#
#	Create by Voli

    /defaults/adduser-abc || exit 1		## Ha kell akkor ujra alkotjuk az abc felhasználót

    ## Jogosultság beállítása
    [ -e /dev/console ] && chown abc:abc /dev/console
    find /config 	! \( -user abc -a -group abc \) -exec chown -Lc abc:abc {} +
    find /downloads	! \( -user abc               \) -exec chown -Lc abc:    {} +

    Param_WebUI_Port=${WebUI_Port:+--port "$WebUI_Port"}
    Param_Log_Level=${LOG_LEVEL:+--log-level="$LOG_LEVEL"}

    umask $UMASK
    HOME=/config && cd $HOME

    exec chpst -u abc:abc /usr/bin/transmission-daemon --foreground 						\
				--config-dir /config --download-dir /downloads --watch-dir /config/watch 	\
				${Param_WebUI_Port} ${Param_Log_Level}

##--log-level=info 	error, info, debug
## --logfile /dev/stdout
