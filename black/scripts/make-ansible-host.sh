#!/bin/bash
# # incus rm --force comp-ansible-host
# #incus network rm localbr1 
# #incus network rm localbr2 
# #incus network rm cloudbr1 
# #incus network rm cloudbr2
# echo "==================== create networkss"
# echo "[+] adding localbr1 and cloudbr1"
# incus network create localbr1 ipv4.address=10.0.1.254/24 network=UPLINK ipv4.nat=true ipv6.address=none ipv6.nat=false
# incus network create cloudbr1 ipv4.address=192.168.1.254/24 network=UPLINK ipv4.nat=true ipv6.address=none ipv6.nat=false
# echo "[+] adding localbr2 and cloudbr2"
# incus network create localbr2 ipv4.address=10.0.2.254/24 network=UPLINK ipv4.nat=true ipv6.address=none ipv6.nat=false
# incus network create cloudbr2 ipv4.address=192.168.2.254/24 network=UPLINK ipv4.nat=true ipv6.address=none ipv6.nat=false
# incus init images:ubuntu/noble comp-ansible-host
# incus start comp-ansible-host
# sleep 2
# incus network attach localbr1 comp-ansible-host eth1
# incus network attach cloudbr1 comp-ansible-host eth2
# incus network attach localbr2 comp-ansible-host eth3
# incus network attach cloudbr2 comp-ansible-host eth4
# incus config device set comp-ansible-host eth1 ipv4.address=10.0.1.253
# incus config device set comp-ansible-host eth2 ipv4.address=192.168.1.253
# incus config device set comp-ansible-host eth3 ipv4.address=10.0.2.253
# incus config device set comp-ansible-host eth4 ipv4.address=192.168.2.253
# echo "[+] adding routes holy fuck"
# incus exec comp-ansible-host -- /bin/bash -c "ip addr add 10.0.1.253/24 dev eth1"
# incus exec comp-ansible-host -- /bin/bash -c "ip addr add 192.168.1.253/24 dev eth2"
# incus exec comp-ansible-host -- /bin/bash -c "ip addr add 10.0.2.253/24 dev eth3"
# incus exec comp-ansible-host -- /bin/bash -c "ip addr add 192.168.2.253/24 dev eth4"
# incus exec comp-ansible-host -- /bin/bash -c "ip link set eth1 up"
# incus exec comp-ansible-host -- /bin/bash -c "ip link set eth2 up"
# incus exec comp-ansible-host -- /bin/bash -c "ip link set eth3 up"
# incus exec comp-ansible-host -- /bin/bash -c "ip link set eth4 up"
# incus exec comp-ansible-host -- /bin/bash -c  "apt update" >/dev/null 2>&1
# echo "[+] apt install shit"
# incus exec comp-ansible-host -- /bin/bash -c 'DEBIAN_FRONTEND=noninteractive apt-get install -y ansible net-tools' >/dev/null 2>&1
# echo "[+] make user ansible"
# incus exec comp-ansible-host -- bash -c "useradd -m -s /bin/bash 'ansible'"
# echo "[+] naje user ansible sudo"
# incus exec comp-ansible-host -- usermod -aG sudo ansible
# echo "[+] change ansible paasswd"
# incus exec comp-ansible-host -- bash -c "echo ansible:ansible | chpasswd"
# echo "[+] make dir in .ssh"
# incus exec comp-ansible-host -- /bin/bash -c 'su ansible -c "mkdir --mode=750 /home/ansible/.ssh"'
# #incus exec comp-ansible-host -- /bin/bash -c 'su ansible -c "ssh-keygen -t rsa -b 4096 -f /home/ansible/.ssh/id_rsa -P \"\""'
# #incus file pull comp-ansible-host/home/ansible/.ssh/id_rsa.pub .
# #incus file pull comp-ansible-host/home/ansible/.ssh/id_rsa .
# echo "[+] pushing shit in"
# echo "[+] pushing id_rsa.pub in"
# incus file push id_rsa.pub comp-ansible-host/home/ansible/.ssh/id_rsa.pub
# echo "[+] pushing id_rsa in"
# incus file push id_rsa comp-ansible-host/home/ansible/.ssh/id_rsa
# incus file push inventory.ini comp-ansible-host/home/ansible/inventory.ini
# echo done
incus network detach localbr1 comp-ansible-host eth1
incus network detach cloudbr1 comp-ansible-host eth2
incus network detach localbr2 comp-ansible-host eth3
incus network detach cloudbr2 comp-ansible-host eth4
incus network attach localbr1 comp-ansible-host eth1
incus network attach cloudbr1 comp-ansible-host eth2
incus network attach localbr2 comp-ansible-host eth3
incus network attach cloudbr2 comp-ansible-host eth4
incus config device set comp-ansible-host eth1 ipv4.address=10.0.1.253
incus config device set comp-ansible-host eth2 ipv4.address=192.168.1.253
incus config device set comp-ansible-host eth3 ipv4.address=10.0.2.253
incus config device set comp-ansible-host eth4 ipv4.address=192.168.2.253
echo "[+] adding routes holy fuck"
incus exec comp-ansible-host -- /bin/bash -c "ip addr add 10.0.1.253/24 dev eth1"
incus exec comp-ansible-host -- /bin/bash -c "ip addr add 192.168.1.253/24 dev eth2"
incus exec comp-ansible-host -- /bin/bash -c "ip addr add 10.0.2.253/24 dev eth3"
incus exec comp-ansible-host -- /bin/bash -c "ip addr add 192.168.2.253/24 dev eth4"
incus exec comp-ansible-host -- /bin/bash -c "ip link set eth1 up"
incus exec comp-ansible-host -- /bin/bash -c "ip link set eth2 up"
incus exec comp-ansible-host -- /bin/bash -c "ip link set eth3 up"
incus exec comp-ansible-host -- /bin/bash -c "ip link set eth4 up"