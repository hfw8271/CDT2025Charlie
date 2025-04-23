#!/bin/bash
# Usage: ./snapshot.sh snapshot_suffix

if [ $# -ne 1 ]; then
  echo "Usage: $0 snapshot_suffix"
  exit 1
fi

SNAPSHOT_NAME="snapshot-$1"

dinosaurs=(
    "Plesiosaurus1"
    "Plesiosaurus2"
    "Tyrannosaurus1"
    "Tyrannosaurus2"
    "Velociraptor1"
    "Velociraptor2"
    "Pterodactyl1"
    "Pterodactyl2"
)

for instance in "${dinosaurs[@]}"; do
  echo "Creating snapshot for $instance with name $SNAPSHOT_NAME"
  incus snapshot create "$instance" "$SNAPSHOT_NAME"
done