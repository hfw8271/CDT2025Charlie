#!/bin/bash

# make sure we are on right project
PROJECTDIR=`find ~/ -maxdepth 1 | grep cdt | head -n1`
PROJECT=`basename $PROJECTDIR`
echo "Switching to Project $PROJECT"
incus remote switch gcicompute02
incus project switch $PROJECT

#echo "==================== create networkss"
#echo "[+] adding localbr1 and cloudbr1"
#incus network create localbr1 ipv4.address=10.0.1.254/24 ipv4.nat=true
#incus network create cloudbr1 ipv4.address=192.168.1.254/24 ipv4.nat=true
#echo "[+] adding localbr2 and cloudbr2"
#incus network create localbr2 ipv4.address=10.0.2.254/24 ipv4.nat=true
#incus network create cloudbr2 ipv4.address=192.168.2.254/24 ipv4.nat=true
echo "==================== create VMs"
# echo "[+] adding Allosaurus (Debian 12 - Thunderbird)"
# incus init images:debian/12 "Allosaurus1" --network localbr1 -d eth0,ipv4.address=10.0.1.77
# incus init images:debian/12 "Allosaurus2" --network localbr2 -d eth0,ipv4.address=10.0.2.77
# #echo "[+] adding Tyranosaurus (Windows Server 2016 - AD DS & DNS)"
# #incus launch oszoo:7642c4606861 "Tyrannosaurus1" --network localbr1 -d eth0,ipv4.address=10.0.1.9 --vm -d root,size=50GiB
# #incus launch oszoo:7642c4606861 "Tyrannosaurus2" --network localbr2 -d eth0,ipv4.address=10.0.2.9 --vm -d root,size=50GiB
# echo "[+] adding Triceratops (Rocky 9 - NGINX)"
# incus init images:rockylinux/9 "Triceratops1" --network cloudbr1 -d eth0,ipv4.address=192.168.1.12 
# incus init images:rockylinux/9 "Triceratops2" --network cloudbr2 -d eth0,ipv4.address=incus launch oszoo:bb044887b0fb "Pterodactyl2" --network cloudbr2 -d eth0,ipv4.address=10.0.2.67 --vm -d root,size=50GiB
#echo "[+] adding Brachiosaurus (Debian 11 - Graylog)"
#incus init images:ubuntu/jammy "Brachiosaurus1" --network cloudbr1 -d eth0,ipv4.address=192.168.1.89
#incus init images:ubuntu/jammy "Brachiosaurus2" --network cloudbr2 -d eth0,ipv4.address=192.168.2.89
# echo "[+] adding Stegosaurus (Ubuntu 22 - MySQL)"
# incus init images:ubuntu/jammy "Stegosaurus1" --network cloudbr1 -d eth0,ipv4.address=192.168.1.109
# incus init images:ubuntu/jammy "Stegosaurus2" --network cloudbr2 -d eth0,ipv4.address=192.168.2.109
echo "[+] adding Gigantosaurus (Alt linux - ICMP)"
incus init images:ffdf95627542  "Gigantosaurus1" --network localbr1 -d eth0,ipv4.address=10.0.1.1
incus init images:ffdf95627542  "Gigantosaurus2" --network localbr2 -d eth0,ipv4.address=10.0.2.1
#echo "[+} adding Plesiosaurus (Windows Server 2016 - Sysmon)"
#incus launch oszoo:7642c4606861 "Plesiosaurus1" --network localbr1 -d eth0,ipv4.address=10.0.1.43 --vm -d root,size=50GiB
#incus launch oszoo:7642c4606861 "Plesiosaurus2" --network localbr2 -d eth0,ipv4.address=10.0.2.43 --vm -d root,size=50GiB
#echo "[+} adding Velociraptor (Windows Server 2019 - SMB)"
#incus launch oszoo:7cf7efb5de93 "Velociraptor1" --network localbr1 -d eth0,ipv4.address=10.0.1.67 --vm -d root,size=50GiB
#incus launch oszoo:7cf7efb5de93 "Velociraptor2" --network localbr2 -d eth0,ipv4.address=10.0.2.67 --vm -d root,size=50GiB
#echo "[+} adding Velociraptor (Windows Server 2022 - Xitami)"
#incus launch oszoo:a748bba42c43 "Pterodactyl1" --network cloudbr1 -d eth0,ipv4.address=192.168.1.34 --vm -d root,size=50GiB
#incus launch oszoo:a748bba42c43 "Pterodactyl2" --network cloudbr2 -d eth0,ipv4.address=192.168.2.34 --vm -d root,size=50GiB
