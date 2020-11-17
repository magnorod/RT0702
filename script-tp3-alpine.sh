!/bin/bash

f_config="answerfile"
setup-alpine -c answerfile

sudo sed -i "s/KEYMAPOPTS=.*/KEYMAPOPTS="fr ca" /g" $f_config
sudo sed -i "s/HOSTNAMEOPTS=.*/HOSTNAMEOPTS="-n alpine-perso" /g" $f_config
sudo sed -i "s/DISKOPTS=.*/DISKOPTS="-m sys /dev/sda" /g" $f_config
sudo sed -i "s/PROXYOPTS=.*/#PROXYOPTS" /g" $f_config
