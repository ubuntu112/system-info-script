#!/bin/bash

echo "Starting assignment2.sh script..."

# Configure netplan for 192.168.16 network interface
NETPLAN_CONFIG="/etc/netplan/01-netcfg.yaml"
if ! grep -q "192.168.16.21/24" "$NETPLAN_CONFIG"; then
    echo "Configuring netplan for 192.168.16 network..."
    # Add netplan configuration here
else
    echo "Netplan is already configured."
fi

# Update /etc/hosts file
HOSTS_FILE="/etc/hosts"
if ! grep -q "192.168.16.21 server1" "$HOSTS_FILE"; then
    echo "Updating /etc/hosts file..."
    # Update hosts file here
else
    echo "/etc/hosts is already up to date."
fi

# Install and configure apache2
if ! dpkg -l | grep -q apache2; then
    echo "Installing apache2..."
    apt-get update
    apt-get install -y apache2
else
    echo "apache2 is already installed."
fi

# Install and configure squid
if ! dpkg -l | grep -q squid; then
    echo "Installing squid..."
    apt-get install -y squid
else
    echo "squid is already installed."
fi

# Configure ufw firewall
echo "Configuring ufw firewall..."
ufw allow in on mgmt to any port 22
ufw allow in on any to any port 80
ufw allow in on any to any port 3128
ufw enable

# Create user accounts with SSH keys
USERS=("dennis" "aubrey" "captain" "snibbles" "brownie" "scooter" "sandy" "perrier" "cindy" "tiger" "yoda")
for user in "${USERS[@]}"; do
    if ! id -u "$user" &>/dev/null; then
        echo "Creating user $user..."
        useradd -m -s /bin/bash "$user"
    else
        echo "User $user already exists."
    fi
    echo "Configuring SSH keys for $user..."
    # Add SSH key configuration here
done

# Specific configuration for dennis
if ! groups dennis | grep -q "\bsudo\b"; then
    usermod -aG sudo dennis
fi

echo "Script completed."
