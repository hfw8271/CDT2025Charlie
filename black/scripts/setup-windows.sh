#!/bin/bash
set -euo pipefail

print_command() {
    echo "$(tput setaf 6)>>> $1$(tput sgr0)"
    eval "$1"
}

print_message() {
    echo "$(tput setaf 2)$1$(tput sgr0)"
}

print_command "PROJECTDIR=\$(find ~/ -maxdepth 1 | grep cdt | head -n1)"
if [ -z "$PROJECTDIR" ]; then
    print_message "Error: No CDT project directory found"
    exit 1
fi
# Extract just the project directory name
print_command "PROJECT=\$(basename \"\$PROJECTDIR\")"

# Configure Ansible environment variables for Incus connection
# These tell Ansible which Incus remote and project to use
export ANSIBLE_INCUS_REMOTE=gcicompute02
export ANSIBLE_INCUS_PROJECT="$PROJECT"

print_command "incus remote switch gcicompute02"
print_command "incus project switch ${PROJECT}"

# Create Ansible inventory for Windows VMs
print_message "Creating temporary inventory..."
print_command "cat > inventory.tmp << 'EOF'
[windows]
Plesiosaurus1 ansible_host=10.0.1.43
Plesiosaurus2 ansible_host=10.0.2.43
Tyrannosaurus1 ansible_host=10.0.1.9
Tyrannosaurus2 ansible_host=10.0.2.9
Pterodactyl1 ansible_host=192.168.1.34
Pterodactyl2 ansible_host=192.168.2.34
Velociraptor1 ansible_host=10.0.1.67
Velociraptor2 ansible_host=10.0.2.67

[windows:vars]
ansible_user=ansible
ansible_password=ansible
ansible_connection=winrm
ansible_winrm_server_cert_validation=ignore
ansible_winrm_transport=ntlm
EOF
"

# Launch function
launch_vm() {
    local name=$1
    local ip=$2
    local net=$3

    print_message "Launching ${name} (${ip})..."
    print_command "incus launch oszoo:7642c4606861 ${name} \
        --network ${net} \
        -d eth0,ipv4.address=${ip} \
        --vm \
        -d root,size=50GiB"
}

launch_2019() {
    local name=$1
    local ip=$2
    local net=$3

    print_message "Launching ${name} (${ip})..."
    print_command "incus launch oszoo:7cf7efb5de93 ${name} \
        --network ${net} \
        -d eth0,ipv4.address=${ip} \
        --vm \
        -d root,size=50GiB"
}

launch_2022() {
    local name=$1
    local ip=$2
    local net=$3

    print_message "Launching ${name} (${ip})..."
    print_command "incus launch oszoo:a748bba42c43 ${name} \
        --network ${net} \
        -d eth0,ipv4.address=${ip} \
        --vm \
        -d root,size=50GiB"
}

# Deploy all 4 VMs
launch_vm Plesiosaurus1 10.0.1.43 localbr1
launch_vm Plesiosaurus2 10.0.2.43 localbr2
launch_vm Tyrannosaurus1 10.0.1.9 localbr1
launch_vm Tyrannosaurus2 10.0.2.9 localbr2
launch_2022 Pterodactyl1 192.168.1.34 cloudbr1
launch_2022 Pterodactyl2 192.168.2.34 cloudbr2
launch_2019 Velociraptor1 10.0.1.67 localbr1
launch_2019 Velociraptor2 10.0.2.67 localbr2

print_message "Waiting for deployment container to be ready..."
print_command "sleep 10"

# Create an Ansible playbook to configure the deployment container
print_message "Creating temporary Ansible playbook for deployment setup..."
cat > deploy_setup.yml << 'EOF'
---
- hosts: deployment
  connection: incus
  gather_facts: true
  tasks:
    - name: Wait for container to be ready
      wait_for_connection:
        timeout: 30

    - name: Add inventory hostnames to /etc/hosts
      lineinfile:
        path: /etc/hosts
        line: "{{ item }}"
        state: present
      loop:
        - "10.0.1.43 Plesiosaurus1.example.local"
        - "10.0.2.43 Plesiosaurus2.example.local"
        - "10.0.1.9 Tyrannosaurus1.example.local"
        - "10.0.2.9 Tyrannosaurus2.example.local"
        - "192.168.1.34 Pterodactyl1.example.local"
        - "192.168.2.34 Pterodactyl2.example.local"
        - "10.0.1.67 Velociraptor1.example.local"
        - "10.0.2.67 Velociraptor2.example.local"

    - name: Add Ansible PPA
      shell: |
        apt-get update
        apt-get install -y software-properties-common
        add-apt-repository --yes --update ppa:ansible/ansible

    - name: Install Ansible and dependencies
      apt:
        name: 
          - ansible
          - python3-pip
          - python3-requests
          - nano
        state: present
        update_cache: yes
EOF

print_command "cat > deploy_inventory.ini << 'EOF'
[deployment]
comp-ansible-host ansible_connection=community.general.incus ansible_incus_remote=gcicompute02 ansible_incus_project=${PROJECT}
EOF
"

# Configure the deployment container using Ansible
print_message "Configuring deployment container..."
export DEBIAN_FRONTEND=noninteractive
if ! ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -v -i deploy_inventory.ini deploy_setup.yml; then
    print_message "Failed to configure deployment container"
    exit 1
fi


print_message "Waiting for Windows VMs to be ready..."
max_attempts=90
attempt=1

while [ $attempt -le $max_attempts ]; do
    print_message "Attempt $attempt of $max_attempts..."
    
    # Copy inventory to deployment container and run health check
    print_command "incus file push inventory.tmp comp-ansible-host/root/inventory"
    if print_command "incus exec comp-ansible-host -- ansible windows -i /root/inventory -m win_ping 2>/dev/null"; then
        print_message "All Windows VMs are ready!"
        break
    fi
    
    print_command "sleep 20"
    attempt=$((attempt + 1))
done

if [ $attempt -gt $max_attempts ]; then
    print_message "Timeout waiting for Windows VMs to be ready"
    exit 1
fi
