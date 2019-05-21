#!/bin/sh
#
#	Create by Voli

/defaults/setup-munin.sh

## Minden plugin-t ugyanabba a csoportba rakom
## 'print("graph_category filetransfer")";'

cd /defaults/munin
ls |while read a; do
    sed -i "s/filetransfer/Torrent/g" $a
done


	## Az alternatívák elkészítése
for pl in bandwidth connections states ; do
    [ ! -e /defaults/munin/deluge_$pl ] && ln -s deluge_ /defaults/munin/deluge_$pl
done
