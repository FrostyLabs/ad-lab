#!/bin/bash

# Configure static IP for eth1
cat <<EOF | sudo tee /etc/netplan/01-eth1-static.yaml
network:
  version: 2
  ethernets:
    eth1:
      addresses:
        - 192.168.139.14/24
      routes:
        - to: default
          via: 192.168.139.1
      nameservers:
        addresses:
          - 192.168.139.10
EOF

sudo netplan apply
echo "Static IP configured for eth1"
