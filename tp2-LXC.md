## RT0702 TP2 LXC



## Réalisez l’installation des packages nécessaires à l’exécution d’une machine virtuelle LXC.


*sudo apt install lxc -y && apt install lxctl -y*




### Créer un invité de type Ubuntu

sudo lxc-create -t download -n container_bionic -- -d ubuntu -r bionic -a amd64



###  1) Récupérez la liste des conteneurs utilisables sur la machine

lxc-ls -f

###  2) Démarrez le conteneur

lxc-start -n container_bionic -d

### 3) Sur l’hôte récupérez les informations suivantes:

* a) informations d’exécution du conteneur :

*lxc-info -n container_bionic*

* b) état du filesystem de l’hôte :

*df -h*


* c) Position du filesystem de l'invité sur l'hôte:

*lxc-attach -n container_bionic -- df -h*

* d) processus de l'hôte:

*ps -aux*

### 4) Connectez-vous à la console du conteneur


* a) vérifier l'accès et les droits dans l'invité:


Il n'est pas possible de se connecter directement via la console du conteneur.

On doit accéder au shell du conteneur:

*lxc-attach -n container_bionic*

puis dans le conteneur
passwd ubuntu (pour définir un mot de passe)

On peut maintenant se connecter à la console:

*lxc-console -n container_bionic*

b) État du filesystem de l’invité, que remarquez-vous (cf item 3.b)

/dev/mapper/ubuntu--vg-ubuntu--lv  6.9G  4.1G  2.4G  64% /
none                               492K     0  492K   0% /dev
tmpfs                              493M     0  493M   0% /dev/shm
tmpfs                              493M  104K  493M   1% /run
tmpfs                              5.0M     0  5.0M   0% /run/lock
tmpfs                              493M     0  493M   0% /sys/fs/cgroup
tmpfs                               99M     0   99M   0% /run/user/1000


root@usermrt:~# df -h
Filesystem                         Size  Used Avail Use% Mounted on
udev                               462M     0  462M   0% /dev
tmpfs                               99M  696K   98M   1% /run
/dev/mapper/ubuntu--vg-ubuntu--lv  6.9G  4.1G  2.4G  64% /
tmpfs                              493M     0  493M   0% /dev/shm
tmpfs                              5.0M     0  5.0M   0% /run/lock
tmpfs                              493M     0  493M   0% /sys/fs/cgroup
/dev/sda2                          976M  145M  765M  16% /boot
tmpfs                               99M     0   99M   0% /run/user/1000

On remarque que certains fichiers sont identiques au niveau de la taille:
* /dev/mapper/ubuntu--vg-ubuntu--lv    mounted on /
* tmpfs                                mounted on /dev/shm                             
* tmpfs                                mounted on /sys/fs/cgroup
* tmpfs                                mounted on /run/user/1000


Montage qui ne sont pas présent:
* /dev/sda2   mounted on /boot
* tmpfs mounted on /run/user/1000 

c) Processus en exécution sur l’invité que remarquez-vous (cf question 3.d) ?

hôte:
  PID TTY          TIME CMD
 5862 pts/0    00:00:00 agetty
 6152 pts/0    00:00:00 sudo
 6153 pts/0    00:00:00 bash
 6194 pts/0    00:00:00 ps


invité: 
 PID TTY          TIME CMD
  284 pts/0    00:00:00 bash
  300 pts/0    00:00:00 ps

 Par conséquent, il manque sudo et agetty sur l'invité






5)
 a) ? 

b) État du filesystem de l’invité, que remarquez-vous (cf item 3.b)

root@usermrt:~# lxc-attach -n container_bionic -- df -h
Filesystem                         Size  Used Avail Use% Mounted on
/dev/mapper/ubuntu--vg-ubuntu--lv  6.9G  4.1G  2.4G  64% /
none                               492K     0  492K   0% /dev
tmpfs                              493M     0  493M   0% /dev/shm
tmpfs                              493M   84K  493M   1% /run
tmpfs                              5.0M     0  5.0M   0% /run/lock
tmpfs                              493M     0  493M   0% /sys/fs/cgroup


root@usermrt:~# df -h
Filesystem                         Size  Used Avail Use% Mounted on
udev                               462M     0  462M   0% /dev
tmpfs                               99M  696K   98M   1% /run
/dev/mapper/ubuntu--vg-ubuntu--lv  6.9G  4.1G  2.4G  64% /
tmpfs                              493M     0  493M   0% /dev/shm
tmpfs                              5.0M     0  5.0M   0% /run/lock
tmpfs                              493M     0  493M   0% /sys/fs/cgroup
/dev/sda2                          976M  145M  765M  16% /boot
tmpfs                               99M     0   99M   0% /run/user/1000

On remarque que certains fichiers sont identiques au niveau de la taille:
* /dev/mapper/ubuntu--vg-ubuntu--lv    mounted on /
* tmpfs                                mounted on /dev/shm                             
* tmpfs                                mounted on /sys/fs/cgroup

Montage qui ne sont pas présent:
* /dev/sda2   mounted on /boot
* tmpfs mounted on /run/user/1000 

c) 

hôte:
  PID TTY          TIME CMD
 5862 pts/0    00:00:00 agetty
 6152 pts/0    00:00:00 sudo
 6153 pts/0    00:00:00 bash
 6194 pts/0    00:00:00 ps


invité: 
PID TTY          TIME CMD
   75 pts/3    00:00:00 agetty
  265 pts/3    00:00:00 ps
 Par conséquent, il manque sudo et bash sur l'invité

