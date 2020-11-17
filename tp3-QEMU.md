# RT0702 QEMU

## Installation des packages nécessaires à l’exécution d’une machine virtuelle Qemu

* sudo apt install qemu -y

## Installation d’une machine virtuelle Alpine dans Qemu. Vous réaliserez une installation système.

Vous utiliserez un disque virtuel de 2Go.

Création d'un fichier de 2Go qui deviendra un disque virtuel :

* qemu-img create -f qcow2 alpine.img 2G

Téléchargement du fichier iso de la distribution Alpine:

* wget http://dl-cdn.alpinelinux.org/alpine/v3.12/releases/x86_64/alpine-standard-3.12.1-x86_64.iso


## Démarrez la machine virtuelle selon la configuration suivante :

* 256 Mo de RAM
* clavier en français
* mode réseau user


le mode graphique SDL (Simple Direct Media Layer) est activé par défaut

Lancement de l'image Alpine:


qemu-system-x86_64 
 -m 256  mémoire de 256 MO
 -display curses  utilisation de curses pour la sortie video
 -k fr-ca \ clavier français-canadien
 -boot d \ le système bootera sur d (first CD-ROM)
 -cdrom alpine-standard-3.12.1-x86_64.iso \ chemin du fichier iso
 -drive file=./alpine.img,format=qcow2 \ défini un nouveau disque au format qcow2
 -net user \ utilisation du user mode network
 -net nic \ création d'une nouvelle interface


qemu-system-x86_64 -m 256 -display curses -boot d -cdrom alpine-standard-3.12.1-x86_64.iso -drive file=alpine.img,format=qcow2 -net user -net nic

Installation:
https://wiki.alpinelinux.org/wiki/Alpine_setup_scripts
3 modes d'install possible , diskless, data, sys

Récupérer un fichier answerfile pour le modifier par la suite:
* setup-alpine -c answerfile


options à modifier dans le fichier answerfile récupéré
 KEYMAPOPTS="fr fr"
 HOSTNAMEOPTS="-n alpine-perso"
 DISKOPTS="-m sys /dev/sda"
 #PROXYOPTS="http://webproxy:8080"

Lancement de l'installation avec l'answerfile perso:
* setup-alpine -e -f answerfile


![](tp3-img/install-ok.png)



### Démarrage de la VM
qemu-system-x86_64 -m 256 -k fr -net nic -net user -hda alpine.img -display curses

### tester de connexion réseau


![](tp3-img/config-reseau.png)

ping de l'invité vers le serveur dhcp OK
* ping 10.0.2.2

ping de l'hote vers l'invité KO

* ping 10.0.2.15

installation du paquet curl et requete http sur le site www.google.fr

* apk add curl

* curl -I http://www.google.fr | grep HTTP 

![](tp3-img/http-ok.png)

on obtient OK donc accès vers l'extérieur possible 

## Question 4

* apk add openssh-server && apk add apache2
* apk update

adduser -h /home/user1 -s /bin/sh -G user1


Pour activer ce forward de port, il faut changer le mode réseau de la VM

tcp:2222::20
tcp:8080::80 

qemu-system-x86_64 -k fr -m 256 -net nic -net user,hostfwd=tcp::8080-:80  -hda alpine.img -display curses  OK pour http

![](tp3-img/http-ok-sc.png)

curl -I http://172.18.10.19:8080 | grep HTTP | awk {print $2}