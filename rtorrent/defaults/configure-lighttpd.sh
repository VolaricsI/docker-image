#!/bin/sh
#
#	Create by Voli

## Minden könyvtára a "/tmp/lighttpd" alá kerül
    mkdir -p /tmp/lighttpd/compress /tmp/lighttpd/uploads && chown -R abc:abc /tmp/lighttpd || exit 11

## saját konfig elhelyezése
    rm /etc/lighttpd/*.conf && cp /defaults/lighttpd* /etc/lighttpd/ && mv /etc/lighttpd/lighttpd.conf.example /etc/lighttpd/lighttpd.conf || exit 12
