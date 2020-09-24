### TP1- Introduction à la virtualisation RT0702
### Premiers tests

tuto install : http://en.ig.ma/notebook/2012/virtualbox-guest-additions-on-ubuntu-server

mode d'accès réseau par défaut de la machine : NAT

1) tester l'accès au réseau depuis l'invité
* requete ICMP vers  www.google.fr OK
* impossible de joindre l'hôte

2)Donnez les adresses IP des différentes machines (hôtes et invités)


a)coté hôte
* adresse ip :192.168.1.34
* masque: 255.255.255.0
* passerelle: 192.168.1.254

b)coté invité:
* adresse ip : 10.0.2.15
* masque: 255.255.255.0
* passerelle: 10.0.2.254

3) Tester l’accès entre l'invité et l'hôte

a)ping hôte -> invité KO
b)ping invité -> hôte OK


4) Réalisez l’installation sur l’invité d’un serveur WEB
 sudo apt install apache2 -y


5)Configurez un répertoire partagé entre l’hôte et l’invité. Le répertoire partagé sera accessible par un
ensemble d’utilisateurs, et pas seulement par un accès root.

point de montage du dossier partagé sur VirtualBox (hôte) est **/media/dossier-partage**

droit par défaut sur ce dossier rwxrwx--- root vboxsf
Il faut ajouter l'utilisateur marc au groupe vboxsf pour que cet utilisateur puisse accéder au contenu du dossier partagé avec tous les droits

en root:
adduser marc vboxsf 

l'utilisateur marc peut désormais accéder à /media/dossier-partage


### Duplication de machine
via la commande **ip addr show**

clone intégral:
* adresse ip: 10.0.2.15
* masque: 255.255.255.0
* passerelle: 10.0.2.254
* adresse MAC: 08:00:27:61:f8:2c
* taille sur le disque : 2.86 Go

clone lié:
* adresse ip: 10.0.2.15
* masque: 255.255.255.0
* passerelle: 10.0.2.254
* adresse MAC: 08:00:27:61:f8:2c
* taille sur le disque : 34.5 Mo


On constate une nette différence de taille sur le disque entre le clone intégral et lié 

### Forward de port

La requete http://adressehote:8080 réalisée sur l'hôte est redirigée sur le port 80  de l'invité, en conséquence on obtient la réponse du serveur web qui se trouve sur l'invité. 

La requête ssh adressehote -p 2222 a bien été relayé sur le serveur ssh de l'invité (port 22) (testé via Puttty)

### Configuration réseau et DHCP
configuration réseau privé hôte:
adresse ip :192.168.56.101/24

configuration de la plage
192.168.0.1 à 192.168.0.30 dans le serveur DHCP à VirtualBox

Fichier > Gestionnaire de réseau hôte 
interface: configurer la carte automatiquement
Serveur DHCP:
* activer le serveur
* adresse du serveur 192.168.0.31
* masque 255.255.255.0
* limite inférieure 192.168.0.1
* limite supérieure 192.168.0.30

renommage de la nouvelle carte réseau virtuelle en vboxnet2

sur l'invité via la commande
**ip addr show enp0s3**
je constate que l'adresse ip qui a été affecté à l'invité ets bien comprise dans la plage mentionné au serveur DHCP

De plus, je vérifie que le serveur DHCP intégré a VirtualBox est joignable via un **ping 192.168.0.31**

### Gestion du bridge

Le protocole d'expérimentation qui sera utilisé pour déterminer si les 2 acteurs peuvent se joindre est le protocole ICMP.

Le parefeu sur l'hôte Windows sera désactivé pour éviter le rejet des requêtes ICMP venant de l'invité.

Par conséquent, la commande ping sera utilisée
pour la vérification de la connexion à internet on utilisera la commande **ping www.google.fr**

#### NAT:
* hôte -> invité : KO
* invité -> hôte : OK
* invité -> internet : OK
* invité -> invité : OK

#### Réseau ponté(bridge)
* hôte -> invité : OK
* invité -> hôte :  OK
* invité -> internet : OK
* invité -> invité :  OK

#### Réseau privé hôte
* hôte -> invité : OK
* invité -> hôte : KO (network unreachable)
* invité -> internet : KO
* invité -> invité : OK

### Montage réseau
interface 1 loopback (lo):
* adresse MAC 00:00:00:00:00:00
* adresse ip : 127.0.0.1/8
interface 2 en NAT (enp0s3):
* adresse MAC 08:00:27:61:f8:2c
* adresse ip : 10.0.2.15/24
interface 3 en réseau privé hôte (enp0s8):
* adresse MAC: 08:00:27:26:9d:f1
* adresse ip(v6) fe80::a00:27ff:fe26:9df1/64 

Remarque: pour obtenir une adresse ip sur l'interface enp0s8 il est nécessaire de taper la commande suivante  qui va activer l'interface en question :
**sudo ip link set enp0s8 up**


### Accès à l'invité

#### Configurez votre système afin qu'il soit possible de se connecter à distance à la console de l'invité, en se connectant sur l’hyperviseur

Pour se connecter à distance au shell de l'invité directement depuis l'hyperviseur il faut utiliser VBoxManage
1) On liste l'ensemble des VM
**VBoxManage list vms**
"ubuntu-server" {fa251b62-03b3-41ea-a6b9-b042dc473470}
"Clone lié de ubuntu-server" {83c1a7d5-d18d-4922-889c-705462b0ce13}
"ubuntu-server2" {8ed04f34-60fa-4404-b864-a8f8fdda2ca7}

2) Maintenant que l'on connait l'identifiant de notre VM sur laquelle on souhaite utilser le shell (/bin/sh), il suffit d'utiliser l'instruction guestcontrol.

Voici un exemple pour connaitre toutes les informations du système de l'invité

**C:\Program Files\Oracle\VirtualBox> VBoxManage guestcontrol "ubuntu-server" run /bin/sh --username marc --password 12345  --wait-stdout --wait-stderr -- -c "uname -a"**

ce qui renvoie
Linux ubuntu1804-server 4.15.0-118-generic #119-Ubuntu SMP Tue Sep 8 12:30:01 UTC 2020 x86_64 x86_64 x86_64 GNU/Linux


#### Configurez votre système afin qu'il soit possible de se connecter depuis l'hôte en SSH à l'invité.
1) lors de l'installation d'ubuntu server 18.04 j'ai coché l'installation d'openssh-server donc pas besoin d'installer le paquet manuellement


2) Pour se connecter au serveur ssh de l'invité depuis l'hôte , il faut que l'hôte effectue une requête ssh sur l'interface enp0s8 (réseau privé hôte) de l'invité.

**ssh marc@fe80::a00:27ff:fe26:9df1**
il suffit de préciser que l'on souhaite se connecter avec l'utilisateur marc  en utilisant le port par défaut (22)

### Démarrage sans console

adresse ip fixe: fe80::a00:27ff:fe26:9df1/64

1) Création du dossier partagé

 C:\Program Files\Oracle\VirtualBox>VBoxManage sharedfolder add "ubuntu-server" --name "dossier-partage-vbox-manage" --hostpath C:\\Users\\marc\\Documents\\dossier-partage-vbox-manage  --automount --auto-mount-point /media/dossier-partage-vbox-manage

2) Démarrer la VM


**C:\Program Files\Oracle\VirtualBox>VBoxManage startvm "ubuntu-server" --type headless**

3) Connexion par ssh
Il y a redirection du port 2222 de l'hôte vers le port 22 de l'invité

**ssh marc@127.0.0.1 -p 2222**

#### ajout de l'utilisateur www-data au groupe vboxsf
sudo adduser www-data vboxsf

### modification du répertoire par défaut d'apache
 
sudo nano /etc/apache2/sites-available/000-default.conf

le DocumentRoot par défaut:
DocumentRoot /var/www/html

le DocumentRoot après modification (via nano)
DocumentRoot /media/dossier-partage-vbox-manage

### redémarrage du service apache2
sudo service apache2 restart


4) Récupération de la page depuis l'hôte

Utilisation de PowerShell pour télécharger la page qui se trouve sur le serveur web de l'invité
**$clnt=new-object System.Net.WebClient;**
**$clnt.DownloadFile('http://127.0.0.1:8080/','C:\Users\marc\Desktop\index.html')**

La page a correctement été téléchargé
file:///C:/Users/marc/Desktop/index.html


5) Arret de la VM

**VBoxManage controlvm "ubuntu-server" poweroff**













