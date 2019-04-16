
    alpine alapon, github forrásból
	https://github.com/arvidn/libtorrent.git
	https://github.com/qbittorrent/qBittorrent.git

- ``-v /home/qbittorrent/config: /config``: Beállításai és a saját adatbázisa, ha nincs config file akkor egy alapértelmezettel indul

- ``-v /home/qbittorrent/data: /downloads``: Adatok helye

- ``-p 6881:6881/tcp``: Adat csere portja
- ``-p 6881:6881/udp``: dht port

- ``-p 8080:8080``:  Management portja amit a WEBUI_PORT-tal felülbírálható

-  -e WEBUI_PORT : a management port

-  -e PUID : user  ID
-  -e GUID : group ID

-  -e UMASK 	: umask értéke; én a 002-öt szeretem
