#!/bin/bash

# Update package repository
echo "Updating package repository..."
apt-get update -y || yum update -y

# Install required packages for Ansible
echo "Installing Ansible and sshpass..."
apt-get install -y ansible sshpass || yum install -y ansible sshpass

# Check if installation was successful
if ! command -v ansible > /dev/null || ! command -v sshpass > /dev/null; then
    echo "Ansible or sshpass installation failed. Exiting..."
    exit 1
fi

# Generate SSH key pair
echo "Generating SSH key pair..."
ssh-keygen -t rsa -b 4096 -f /root/.ssh/id_rsa -N ""

# Verify key generation
if [ ! -f /root/.ssh/id_rsa.pub ]; then
    echo "SSH key generation failed. Exiting..."
    exit 1
fi

echo "Setup completed successfully. Ansible and sshpass are installed, and SSH key is generated at /root/.ssh/id_rsa.pub."
