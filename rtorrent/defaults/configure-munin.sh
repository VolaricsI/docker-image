#!/bin/sh
#
#	Create by Voli

## Minden plugin-t ugyanabba a csoportba rakom
## 'print "graph_category rTorrent${user}\n";'

cd /defaults/munin
ls |while read a; do
    sed -i 's/filetransfer/Torrent/g' $a
done
