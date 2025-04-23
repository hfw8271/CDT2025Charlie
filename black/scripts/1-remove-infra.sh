#!/bin/bash

# make sure we are on right project
PROJECTDIR=`find ~/ -maxdepth 1 | grep cdt | head -n1`
PROJECT=`basename $PROJECTDIR`
echo "Switching to Project $PROJECT"
incus remote switch gcicompute02
incus project switch $PROJECT

dinosaurs=(
  # "Spinosaurus1"  # Router (pfSense)
  # "Velociraptor1"  # Windows 8.1 (SMB)
  # "Allosaurus1"  # Debian 12 (Thunderbird)
  # "Pterodactyl1"  # Windows Vista (Xitami)
  # "Brachiosaurus1"  # Debian 11 (Graylog)
  # "Brachiosaurus2"  # Debian 11 (Graylog)
  # "Stegosaurus1"  # Ubuntu 22 (mySQL)
  # "Spinosaurus2"  # Router (pfSense)
  # "Velociraptor2"  # Windows 8.1 (SMB)
  # "Allosaurus2"  # Debian 12 (Thunderbird)
  # "Triceratops1"  # Rocky 9 (nginx)
  # "Triceratops2"  # Rocky 9 (nginx)
  # "Pterodactyl2"  # Windows Vista (Xitami)
  # "Stegosaurus2"  # Ubuntu 22 (mySQL)
  # "Gigantosaurus1"  # Alt Linux (ICMP)
  # "Gigantosaurus2"  # Ubuntu 22 (ICMP)
)

# remove old instances
echo "==================== removing old instances"

for dino in "${dinosaurs[@]}"; do
    incus rm --force $dino
done
