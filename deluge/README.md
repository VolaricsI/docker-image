
    alpine/ubuntu alapon, 
    alpine esetén a deluge a testing tárolóból származik most (2018-12-01) nem működő képes


- ``-v /home/deluge/config:/config`` 	: sets up your host's directory to map to the ``/config`` directory in the container.
 Docker will make this folder if it doesn't exist on your host system. This can be moved to anywhere on your host system, but the Docker image needs ``/config`` to exist! This is where you will go if you want to manually change any deluge configuration.

- ``-v /home/deluge/data:/downloads`` 	: similar to above, maps your host's ``/home/deluge/downloads`` directory to map to the ``/downloads`` directory in the container. This is required and is where your files will be stored to by default.

- ``-p 58846:58846`` 	: setups a port forwarding rule for the  management port.
- ``-p 6881:6881`` 	: setups a port forwarding rule for the dht and data in ports

-  -e PUID 	: user  ID
-  -e GUID 	: group ID
-  -e UMASK 	: umask értéke

-  -e PRG_PARAM : további paramétereket lehet hozzáadni a parancssorhoz pl. " -L warning ", bővebb naplózás

- Change the default username and password in your config directory's auth file.

## Default Passwords
Username: deluge
Password: deluge
