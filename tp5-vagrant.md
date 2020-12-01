# TP5 Vagrant

## Q1)Installation de Vagrant

### Téléchargement et installation
* sudo apt-get install vagrant -y

### Q2) 

Rechercher une distrib prise en charge par Vagrant
* https://app.vagrantup.com/boxes/search


### Création du VagrantFile

* mkdir vm-ubuntu-18_04
* cv vm-ubuntu-18_04
* vagrant init "ubuntu/bionic64"


![](tp5-img/vbox-ubuntu.png)


### Création et configuration de la VM
* vagrant up

### Connexion SSH
* vagrant ssh

### Récolte d'info

adresse ip
* ip addr show

![](tp5-img/ip-default-vagrant.png)

disque dur (sytème de fichiers)
* df -h

![](tp5-img/disque.png)

mémoire vive
* free -h

![](tp5-img/free.png)

cpu
* lscpu 

![](tp5-img/lscpu.png)

fichier partagé
* ls /vagrant

![](tp5-img/partage.png)

## Q3)


Pour utiliser le mode GUI virtualbox doit être installé !

modifier le Vagrantfile
![](tp5-img/vagrant-file.png)

* vagrant up
* vagrant provision

![](tp5-img/vagrant-virtualbox.png)

## Q4)

3 modes réseau

### mode forward de port:

forward du port 8080 de l'hôte sur le port 80 de l'invité

modif du Vagrantfile

* config.vm.network "forwarded_port", guest: 80, host: 8080

puis

* vagrant up

le forward de port s'effectue bien

![](tp5-img/port-forward.png)

![](tp5-img/ip-port-forward.png)

|ping source | ping destination | resultat |
|---|---|---|
|hote|invité| ko|
|invite|hote|ok

### mode prive : 

modif du Vagrantfile
* config.vm.network "private_network", ip: "192.168.33.10"
puis
* vagrant up

![](tp5-img/private-network.png)


coté hôte on remarque qu'une interface est créée

![](tp5-img/host.png)



|ping source | ping destination | resultat |
|---|---|---|
|hote|invité| ok|
|invite|hote|ok|



### mode public :

modif du Vagrantfile

* config.vm.network "public_network"

puis

* vagrant up


Utilisation d'un bridge sur l'interface de la carte wi-fi wlp2s0

![](tp5-img/public-bridge.png)

![](tp5-img/public-network-guest.png)

|ping source | ping destination | resultat |
|---|---|---|
|hote|invité| ok|
|invite|hote|ok

## Q5)

utilisation du mode réseau forward de port dans le Vagrantfile
* config.vm.network "forwarded_port", guest: 80, host: 8080

sur l'invité:
* sudo apt install apache2 -y

test sur l'invité:

![](tp5-img/web-invite.png)

test sur l'hôte:

![](tp5-img/web-host.png)





