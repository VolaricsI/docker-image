    Az alpine verzió jelenleg (2018-12-04) sokszor hibás a verzió (rc)


    alpine/ubuntu alapon, 
    alpine esetén a deluge a testing tárolóból származik most (2018-12-01) nem működő képes


- ``-v /home/deluge/config:/config`` 	: sets up your host's directory to map to the ``/config`` directory in the container.
 Docker will make this folder if it doesn't exist on your host system. This can be moved to anywhere on your host system, but the Docker image needs ``/config`` to exist! This is where you will go if you want to manually change any deluge configuration.

- ``-v /home/deluge/data:/downloads`` 	: similar to above, maps your host's ``/home/deluge/downloads`` directory to map to the ``/downloads`` directory in the container. This is required and is where your files will be stored to by default.

- ``-p 58846:58846`` 	: setups a port forwarding rule for the  management port.
- ``-p 6881:6881`` 	: setups a port forwarding rule for the dht and data in ports

-  -e PUID 	: user  ID		#Már az image készítés közben is használható
-  -e GUID 	: group ID		#Már az image készítés közben is használható
-  -e UMASK 	: umask értéke

-  -e PRG_PARAM : további paramétereket lehet hozzáadni a parancssorhoz pl. " -L warning ", bővebb naplózás

- Change the default username and password in your config directory's auth file.

	##A deluge managent felhasználója, ha nincs megadva akkor deluge/deluge
-  -e DELUGE_USERNAME 	:
-  -e DELUGE_PASSWORD 	:


2020-05-01
		Az ubuntu 20.04 hibát dob build-nél ezért visszaálltam a 18.04-re mert a 19.04-nek már nincsenek tárolói
		És még nem akarunk a 2.x-es verzióra váltani, mert hibákat dobál - de megcsinálja - a deluge-console a beállítások során.
