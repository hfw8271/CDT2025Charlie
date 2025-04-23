#!/bin/bash

# incus init images:ubuntu/jammy "logging"
# incus start "logging"
incus network detach localbr1 logging eth1
incus network detach cloudbr1 logging eth2
incus network detach localbr2 logging eth3
incus network detach cloudbr2 logging eth4
incus network attach localbr1 logging eth1
incus network attach cloudbr1 logging eth2
incus network attach localbr2 logging eth3
incus network attach cloudbr2 logging eth4
incus config device set logging eth1 ipv4.address=10.0.1.251
incus config device set logging eth2 ipv4.address=192.168.1.251
incus config device set logging eth3 ipv4.address=10.0.2.251
incus config device set logging eth4 ipv4.address=192.168.2.251
echo "[+] adding routes holy fuck"
incus exec logging -- /bin/bash -c "ip addr add 10.0.1.251/24 dev eth1"
incus exec logging -- /bin/bash -c "ip addr add 192.168.1.251/24 dev eth2"
incus exec logging -- /bin/bash -c "ip addr add 10.0.2.251/24 dev eth3"
incus exec logging -- /bin/bash -c "ip addr add 192.168.2.251/24 dev eth4"
incus exec logging -- /bin/bash -c "ip link set eth1 up"
incus exec logging -- /bin/bash -c "ip link set eth2 up"
incus exec logging -- /bin/bash -c "ip link set eth3 up"
incus exec logging -- /bin/bash -c "ip link set eth4 up"