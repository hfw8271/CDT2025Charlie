echo reverting windows in 10 seconds
sleep 10

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
  echo "Reverting snapshot for $instance with name $SNAPSHOT_NAME"
  incus snapshot delete $instance snapshot-users
  incus snapshot delete $instance snapshot-beforecomp 
  incus snapshot restore "$instance" "$SNAPSHOT_NAME"
done