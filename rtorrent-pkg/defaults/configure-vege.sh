#!/bin/sh
#
#	Create by Voli

	cp -a /app /defaults/app					|exit 10

	chown -RLc abc:abc 	/defaults /app /config /downloads	||exit 20

	[ -x /sbin/apk ] && rm -rf /var/cache/apk			||exit 30
