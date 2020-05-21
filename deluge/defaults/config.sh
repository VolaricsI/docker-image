#!/bin/sh
#
#	Create by Voli

    chmod +x /defaults/* && mv /defaults/start.sh / && mv /defaults/verzio /usr/bin/ && mv /defaults/getupdate /usr/bin/
    /defaults/adduser-abc

    date +%Y-%m-%d 	>/defaults/BuildDate.txt
