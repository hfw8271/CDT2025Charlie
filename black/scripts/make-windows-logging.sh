#!/bin/bash
# incus network detach localbr1 comp-ansible-host eth1
# incus network detach cloudbr1 comp-ansible-host eth2
# incus network detach localbr2 comp-ansible-host eth3
# incus network detach cloudbr2 comp-ansible-host eth4
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
incus launch oszoo:7cf7efb5de93 winlog --vm
# incus network detach localbr1 winlog eth1
# incus network detach cloudbr1 winlog eth2
# incus network detach localbr2 winlog eth3
# incus network detach cloudbr2 winlog eth4
# incus network attach localbr1 winlog eth1 
# incus network attach cloudbr1 winlog eth2
# incus network attach localbr2 winlog eth3
# incus network attach cloudbr2 winlog eth4
incus config device add winlog e1 nic network=localbr1 name=eth1 ipv4.address=10.0.1.250
incus config device add winlog e2 nic network=cloudbr1 name=eth2 ipv4.address=192.168.1.250
incus config device add winlog e3 nic network=localbr2 name=eth3 ipv4.address=10.0.2.250
incus config device add winlog e4 nic network=cloudbr2 name=eth4 ipv4.address=192.168.2.250
# incus config device set winlog eth1 ipv4.address=10.0.1.250
# incus config device set winlog eth2 ipv4.address=192.168.1.250
# incus config device set winlog eth3 ipv4.address=10.0.2.250
# incus config device set winlog eth4 ipv4.address=192.168.2.250