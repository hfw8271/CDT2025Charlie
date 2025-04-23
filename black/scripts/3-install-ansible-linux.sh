#!/bin/bash


dinosaurs=(
#    "Allosaurus1"  # Debian 12 (Thunderbird)
#    "Triceratops1"  # Rocky 9 (nginx)
#    "Brachiosaurus1"  # Debian 11 (Graylog)
#    "Brachiosaurus2"  # Debian 11 (Graylog)
#    "Stegosaurus1"  # Ubuntu 22 (mySQL)
#    "Allosaurus2"  # Debian 12 (Thunderbird)
#    "Triceratops2"  # Rocky 9 (nginx)
#    "Stegosaurus2"  # Ubuntu 22 (mySQL)
   "Gigantosaurus1" # Rocky 9 (freeipa)
   "Gigantosaurus2" #Rocky 9 (freeipa)
)

for dino in "${dinosaurs[@]}"; do
    incus start $dino
done

for target in "${dinosaurs[@]}"; do
    echo "========== Setting up Ansible target ($target)..."
    # Detect OS type
    OS_TYPE=$(incus exec "$target" -- bash -c 'source /etc/os-release && echo "$ID"')

    # Update package list and install necessary packages
    if [[ "$OS_TYPE" == "debian" || "$OS_TYPE" == "ubuntu" || "$OS_TYPE" == "kali" ]]; then
        echo "========== $target is Debian-based. Using APT..."
        incus exec "$target" -- /bin/bash -c "apt update" >/dev/null 2>&1
        incus exec "$target" -- /bin/bash -c "DEBIAN_FRONTEND=noninteractive apt-get install -y ansible net-tools openssh-server" >/dev/null 2>&1
    elif [[ "$OS_TYPE" == "rocky" || "$OS_TYPE" == "rhel" || "$OS_TYPE" == "centos" || "$OS_TYPE" == "fedora" ]]; then
        echo "========== $target is RHEL-based. Using DNF..."
	incus exec "$target" -- /bin/bash -c "sudo dnf install -y epel-release" >/dev/null
        incus exec "$target" -- /bin/bash -c "dnf install -y ansible net-tools openssh-server" >/dev/null 
    fi

    # Create the 'ansible' user with sudo privileges
    incus exec "$target" -- bash -c "useradd -m -s /bin/bash 'ansible'"
    if [[ "$OS_TYPE" == "debian" || "$OS_TYPE" == "ubuntu" || "$OS_TYPE" == "kali" ]]; then
	incus exec "$target" -- usermod -aG sudo ansible
    elif [[ "$OS_TYPE" == "rocky" || "$OS_TYPE" == "rhel" || "$OS_TYPE" == "centos" ]]; then
        incus exec "$target" -- usermod -aG wheel ansible
    fi
    incus exec "$target" -- bash -c "echo ansible:ansible | chpasswd"

    # Set up SSH key authentication
    echo "========== $target - Setting up SSH keys..."
    incus file push id_rsa.pub $target/tmp/id_rsa.pub
    incus exec "$target" -- /bin/bash -c 'su ansible -c "mkdir --mode=750 /home/ansible/.ssh"'
    incus exec "$target" -- /bin/bash -c 'cat /tmp/id_rsa.pub >> /home/ansible/.ssh/authorized_keys'
    incus exec "$target" -- /bin/bash -c 'rm /tmp/id_rsa.pub'
    incus exec "$target" -- /bin/bash -c 'echo "ansible ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/ansible'
    incus exec "$target" -- /bin/bash -c 'chmod 440 /etc/sudoers.d/ansible'
    incus exec "$target" -- /bin/bash -c 'chown ansible:ansible -R /home/ansible'

    # Allow Ansible user to use sudo without password
    incus exec "$target" -- /bin/bash -c 'echo "ansible ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/ansible'
    incus exec "$target" -- /bin/bash -c 'chmod 440 /etc/sudoers.d/ansible'
    incus exec "$target" -- /bin/bash -c 'chown ansible:ansible -R /home/ansible'

    if [[ "$OS_TYPE" == "debian" || "$OS_TYPE" == "ubuntu" || "$OS_TYPE" == "kali" ]]; then
    	incus exec "$target" -- bash -c "systemctl restart ssh"
    	incus exec "$target" -- bash -c "systemctl enable --now ssh"
    elif [[ "$OS_TYPE" == "rocky" || "$OS_TYPE" == "rhel" || "$OS_TYPE" == "centos" ]]; then
	incus exec "$target" -- bash -c "systemctl restart sshd"
    	incus exec "$target" -- bash -c "systemctl enable --now sshd"
    fi
    # Restart and enable SSH service
    echo "========== Restarting SSH on $target..."
done
