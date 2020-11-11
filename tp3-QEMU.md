## RT0702 QEMU

### Installation des packages nécessaires à l’exécution d’une machine virtuelle Qemu

* sudo apt install qemu -y

## Installation d’une machine virtuelle Alpine dans Qemu. Vous réaliserez une installation système.

Vous utiliserez un disque virtuel de 2Go.

Création d'un fichier de 2Go qui deviendra un disque virtuel :

* qemu-img create -f qcow2 alpineimage.img 2G

Téléchargement du fichier iso de la distribution Alpine:

* wget http://dl-cdn.alpinelinux.org/alpine/v3.12/releases/x86_64/alpine-standard-3.12.1-x86_64.iso


### Démarrez la machine virtuelle selon la configuration suivante :

* 256 Mo de RAM
* clavier en français
* mode réseau user


le mode graphique SDL (Simple Direct Media Layer) est activé par défaut

Installation d'ubuntu:

* qemu-system-x86_64 -k fr-ca -m 256 -drive file=./alpineimage.img,format=qcow2 -boot d -cdrom alpine-standard-3.12.1-x86_64.iso -net nic -net user -display curses









