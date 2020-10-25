## RT0702 TP2 LXC



## Réalisez l’installation des packages nécessaires à l’exécution d’une machine virtuelle LXC.


sudo apt install lxc -y && apt install lxctl -y




### Créer un invité de type Ubuntu

sudo lxc-create -t download -n container_bionic -- -d ubuntu -r bionic -a amd64



### Récupérez la liste des conteneurs utilisables sur la machine

lxc-ls -f

### Démarrez le conteneur

lxc-start -n container_bionic -d

### Sur l’hôte récupérez les informations suivantes:

* informations d’exécution du conteneur

**lxc-info -n nomduconteneur**

* etat du filesystem de l’hôte



