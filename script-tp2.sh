#!/bin/bash

nb_var=$#
container_name=$1
distrib_name=$2
release_name=$3
device_name=$4
container_ip=$5
container_gateway=$6


mac_addr=$(sudo ip addr show dev $device_name | grep link |awk '{print $2}')

if [ $nb_var != 6 ]
then
    echo "erreur: nombre de paramètres incorrects"
    echo "./script-perso container_name distrib_name release_name device_name container_ip container_gateway"
else
    netplan_invite="/etc/netplan/10-lxc.yaml"
    config_container="/var/lib/lxc/$container_name/config"

    # creation du conteneur
    sudo lxc-create -t download -n $container_name -- -d $distrib_name -r $release_name -a amd64
    echo "conteneur $container_name créé"

    sudo lxc-start -n $container_name
    

    # modification de l'interface en mode physique
    sudo sed -i "s/lxc.net.0.type.*/lxc.net.0.type = phys/g" $config_container
    sudo sed -i "s/lxc.net.0.link.*/lxc.net.0.link = $device_name/g" $config_container
    sudo sed -i "s/lxc.net.0.hwaddr.*/lxc.net.0.hwaddr = $mac_addr/g" $config_container
    sudo sed -i "s/lxc.net.0.flags.*/lxc.net.0.flags = up/g" $config_container
    echo "interface en mode physique activée"

    

    # modification de netplan sur l'invité
    netplan_cfg="
network:
    ethernets:
        ens18:
            addresses: [$container_ip/24]
            gateway4: $container_gateway
            nameservers:
                addresses:
                - 8.8.8.8
    version: 2"
    sudo lxc-attach -n $container_name -- /bin/bash << COMMANDES
    echo "$netplan_cfg" > /etc/netplan/10-lxc.yaml
    netplan apply
    systemctl restart systemd-networkd
COMMANDES
    echo "modification de netplan effectuée"

    # limitation des ressources
    limit_cfg="
#Memory limit to 256 Mo
lxc.cgroup.memory.limit_in_bytes=268435456

#Utilisation de 50 pourcent du processeur
lxc.cgroup.cpu.cfs_quota_us=500000
lxc.cgroup.cpu.cfs_period_us=1000000"

    echo "$limit_cfg" >> $config_container
    echo "limitation des ressources effectuée"
    
    # installation du serveur apache
    sudo lxc-attach -n $container_name -- /bin/bash << COMMANDES
    apt update -y && apt install apache2 -y
COMMANDES
    echo "installation d'apache effectuée"
fi