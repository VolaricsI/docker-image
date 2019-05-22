#!/bin/sh
#
#	Create by Voli

	## Az alternatívák elkészítése
for pl in bandwidth connections states ; do
    [ ! -e /defaults/munin/deluge_$pl ] && ln -s deluge_ /defaults/munin/deluge_$pl
done
