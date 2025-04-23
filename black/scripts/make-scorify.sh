#!/bin/bash

# incus init images:ubuntu/jammy "scorify"
# incus start "scorify"
incus network detach localbr1 scorify eth1
incus network detach cloudbr1 scorify eth2
incus network detach localbr2 scorify eth3
incus network detach cloudbr2 scorify eth4
incus network attach localbr1 scorify eth1
incus network attach cloudbr1 scorify eth2
incus network attach localbr2 scorify eth3
incus network attach cloudbr2 scorify eth4
incus config device set scorify eth1 ipv4.address=10.0.1.252
incus config device set scorify eth2 ipv4.address=192.168.1.252
incus config device set scorify eth3 ipv4.address=10.0.2.252
incus config device set scorify eth4 ipv4.address=192.168.2.252
echo "[+] adding routes holy fuck"
incus exec scorify -- /bin/bash -c "ip addr add 10.0.1.252/24 dev eth1"
incus exec scorify -- /bin/bash -c "ip addr add 192.168.1.252/24 dev eth2"
incus exec scorify -- /bin/bash -c "ip addr add 10.0.2.252/24 dev eth3"
incus exec scorify -- /bin/bash -c "ip addr add 192.168.2.252/24 dev eth4"
incus exec scorify -- /bin/bash -c "ip link set eth1 up"
incus exec scorify -- /bin/bash -c "ip link set eth2 up"
incus exec scorify -- /bin/bash -c "ip link set eth3 up"
incus exec scorify -- /bin/bash -c "ip link set eth4 up"