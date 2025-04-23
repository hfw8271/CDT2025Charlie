#!/bin/bash
set -euo pipefail

print_command() {
    echo "$(tput setaf 1)[CLEANUP] >>> $1$(tput sgr0)"
    eval "$1"
}

print_message() {
    echo "$(tput setaf 3)$1$(tput sgr0)"
}

# List of VM names
vms=("Plesiosaurus1" "Plesiosaurus2" "Tyrannosaurus1" "Tyrannosaurus2")

for vm in "${vms[@]}"; do
    print_message "Stopping and deleting $vm..."
    
    if incus list --format csv -c n | grep -q "^$vm$"; then
        print_command "incus stop --force $vm"
        print_command "incus delete $vm"
    else
        print_message "$vm does not exist — skipping."
    fi
done

print_message "Cleanup complete: all listed VMs have been removed (if they existed)."
