echo reverting linux in 10 seconds
sleep 10

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
    "Gigantosaurus1" # Ubuntu 22 (FreeIPA)
    "Gigantosaurus2" # Ubuntu 22 (FreeIPA)
)

for instance in "${dinosaurs[@]}"; do
  echo "Reverting snapshot for $instance with name $SNAPSHOT_NAME"
  incus snapshot delete $instance snapshot-users
  incus snapshot delete $instance snapshot-beforecomp 
  incus snapshot restore "$instance" "$SNAPSHOT_NAME"
done