#!/bin/bash
# Usage: ./snapshot.sh snapshot_suffix

if [ $# -ne 1 ]; then
  echo "Usage: $0 snapshot_suffix"
  exit 1
fi

SNAPSHOT_NAME="snapshot-$1"

dinosaurs=(
    "Allosaurus1"  # Debian 12 (Thunderbird)/
    "Allosaurus2"  # Debian 12 (Thunderbird)
    "Triceratops1"  # Rocky 9 (nginx)
    "Triceratops2"  # Rocky 9 (nginx)
    "Brachiosaurus1"  # Debian 11 (Graylog)
    "Brachiosaurus2"  # Debian 11 (Graylog)
    "Stegosaurus1"  # Ubuntu 22 (mySQL)
    "Stegosaurus2"  # Ubuntu 22 (mySQL)
    "Gigantosaurus1" # Ubuntu 22 (WeirdOS)
    "Gigantosaurus2" # Ubuntu 22 (WeirdOS)
)

for instance in "${dinosaurs[@]}"; do
  echo "Creating snapshot for $instance with name $SNAPSHOT_NAME"
  incus snapshot create "$instance" "$SNAPSHOT_NAME"
done