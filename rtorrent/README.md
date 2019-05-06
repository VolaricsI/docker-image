
    alpine/ububntu alapon, rtorrent aminek a kezelő felülete a ruTorrent; lighttpd a webserver ami php-cgi-t futtat maga alatt

    A lighttpd nincs figyelve; csak  a "─screen──rtorrent─" vonal; a lighttpd daemon-ként fut a háttérben

    Az "alpine-3.7"-es visszaosztásban akadozik bár az a stable, az ubuntus tökéletes;

    Az ubuntu-nál az 5000 portot nem kell ki vezetni mivel abban benne van az xmlrpc program amit az ellenorzes program gasznál


    ## Volumes
- 	/config 	Itt vannak a konfigurációk és az rtorrent adatbázisa; 
- 	/downloads 	Ide kerülnek a letöltött file-ok

    ## Ports
    - 	80 	A webes kezelőfelület (ruTorrent)
    - 	6881 	Az rtorrent dht portja
    - 	51413 	Az rtorrent adatcsere portja
    - 	5000 	Az rtorrent vezérlő/lekérdező portja

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


    ## Futó konténerben parancsok
	    -- docker exec containerName verzio				Kiírja a verzi számokat: rtorrent és ruTorrent
	    -- docker exec containerName plugins_disable lista 		Miként a lista => PLUGIN_DISABLE-nál
	    -- docker exec containerName plugins_install 		Minden szükséges programot telepít és ezután engedélyez MINDEN plugint
	    -- docker exec containerName ellenorzes 			Azon könyvtárak/file-ok melyekhez nem tartozik torrent
	    -- docker exec containerName -it connect 			Be csatlakozik az rtorrent felületére ( screen-ben fut az rtorrent )


Label verziókra RFC: http://label-schema.org/rc1/
