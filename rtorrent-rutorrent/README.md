
    alpine alapon, rtorrent aminek a kezelő felülete a ruTorrent

    ## Volumes
- 	/config 	Itt vannak a konfigurációk és az rtorrent adatbázisa; 
- 	/downloads 	Ide kerülnek a letöltött file-ok

    ## Ports
    - 	80 	A webes kezelőfelület (ruTorrent)
    - 	6881 	Az rtorrent dht portja
    - 	51413 	Az rtorrent adatcsere portja
    - 	5000 	Az rtorrent vezérlő/lekérdező portja

    ## Változók amin keresztül állítható a conténer
    - PUID 	: user  ID
    - GUID 	: group ID
    - UMASK 	: umask értéke

    - PHP_MEM 	: a php-fpm memória foglalása, default: 256M

    - DISABLE_PLUGINS 	: Azok a plugin-ek melyeket kikapcsolsz a ruTorrent-ben;
		    ## Lehetséges értékei
		-- "all" 	: minden plugin tiltva.
		-- "clear" 	: minden plugin engedélyezve
		-- "default" 	: A minimal telepítésnél ezek a pluginok nem fognak menni (" spectrogram mediainfo screenshots unpack ")
		-- " spectrogram mediainfo screenshots unpack " 	: ez itt most egy példa lista....

    - INSTALL 	: Értéke bármi és induláskor feltelepíti a hiányzó csomagokat ( ffmpeg sox mediainfo unrar )


    ## Futó konténerben parancsok
	    -- docker exec containerName verzio				Kiírja a verzi számokat: rtorrent és ruTorrent
	    -- docker exec containerName disable_plugins lista 		Miként a DISABLE_PLUGINS-nál
	    -- docker exec containerName ellenorzes 			Azon könyvtárak/file-ok melyekhez nem tartozik torrent


supervisord.py
        if pid:
            process = self.options.pidhistory.get(pid, None)
            if process is None:
                self.options.logger.info('reaped unknown pid %s' % pid)
            else:
                process.finish(pid, sts)
                del self.options.pidhistory[pid]