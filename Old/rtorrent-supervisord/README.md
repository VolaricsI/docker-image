
    alpine/ububntu alapon, rtorrent aminek a kezelő felülete a ruTorrent; ngnix a webserver ami php-fpm -et használ

    Mind három alkalmazást a supervisord felügyeli

    Az rtorrent verziója 9.6 utáni (9.8/9.7) mivel ez már tud daemon-ként futni

    Az ellenőrzést már perl alapon megoldottam így nem kell kivezetni az 5000-es (xmlrpc) porttot


    ## Volumes
- 	/config 	Itt vannak a konfigurációk és az rtorrent adatbázisa; 
- 	/downloads 	Ide kerülnek a letöltött file-ok

    ## Ports
    - 	80 	A webes kezelőfelület (ruTorrent)
    - 	6881 	Az rtorrent dht portja
    - 	51413 	Az rtorrent adatcsere portja
    - 	5000 	Az rtorrent vezérlő/lekérdező portja (nem kell kivezetni)

    ## Változók amin keresztül állítható a Konténer; már a készítéskor használhatók!!!
    - PUID 	: user  ID
    - GUID 	: group ID
    - UMASK 	: umask értéke

    - PLUGIN_DISABLE 	: Azok a plugin-ek melyeket kikapcsolsz a ruTorrent-ben;
		    ## Lehetséges értékei
		-- "" 	: minden plugin engedélyezve
		-- "all" 	: minden plugin tiltva.
		-- "default" 	: Az alap telepítéshez tartozóan eggyes pluginok nem fognak menni (${PLUGIN_DEFAULT_TILTVA})
		-- " spectrogram mediainfo screenshots unpack " 	: ez itt most egy példa lista....

	    ## Jelenleg nem működik
	    - INSTALL 	: Értéke bármi és induláskor feltelepíti a hiányzó csomagokat ( pl. ffmpeg sox mediainfo unrar )

    ## Munin plugin-ek		(vannak csak még nem írtam le a használatukat)


    ## Futó konténerben parancsok
	    -- docker exec containerName verzio				Kiírja a verzi számokat: rtorrent és ruTorrent
	    -- docker exec containerName plugins_disable lista 		Miként a lista => PLUGIN_DISABLE-nál
	    -- docker exec containerName plugins_install 		Minden szükséges programot telepít és ezután engedélyez MINDEN plugint
	    -- docker exec containerName ellenorzes 			Azon könyvtárak/file-ok melyekhez nem tartozik torrent


Label verziókra RFC: http://label-schema.org/rc1/
