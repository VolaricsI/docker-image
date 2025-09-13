#!/bin/sh
#
#	Create by Voli

#!/bin/sh
#
#	Create by Voli

    /defaults/adduser-abc || exit 1		## Ha kell akkor ujra alkotjuk az abc felhasználót

    ## Jogosultság beállítása
    [ -e /dev/console ] && chown abc:abc /dev/console
    find /config /var/www 	! \( -user abc -a -group abc \) -exec chown -Lc abc:abc {} +
    find /downloads		! \( -user abc               \) -exec chown -Lc abc:    {} +

    umask $UMASK
    HOME=/config && cd $HOME

    exec /sbin/runsvdir -P /etc/service
