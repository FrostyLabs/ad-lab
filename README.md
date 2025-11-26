# Active Directory Lab Environment 🏢

A fully (..almost) automated Active Directory lab environment using Vagrant and Ansible. This lab creates a complete Windows domain environment with a domain controller, member servers (including MS SQL Server), a Windows 10 client, and a Linux server integrated with the Active Directory domain.

---

## Table of Contents

- [Overview](#overview)
- [Lab Architecture](#lab-architecture)
- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Vagrantfile Configuration](#vagrantfile-configuration)
- [Shared Folder](#shared-folder)
- [Ansible Configuration](#ansible-configuration)
- [Playbooks](#playbooks)
- [Roles](#roles)
- [Network Topology](#network-topology)
- [Usage](#usage)
- [Troubleshooting](#troubleshooting)

---

## Overview

This lab environment provisions and configures:

- **Domain Controller** (win-dc01): Windows Server 2019 running AD DS
- **Member Server 1** (win-srv01): Windows Server 2019 with MS SQL Server
- **Member Server 2** (win-srv02): Windows Server 2019 with file services
- **Windows Client** (win-client01): Windows 10 workstation
- **Linux Server** (linux-srv01): Ubuntu 24.04 with LAMP stack and domain integration

**Domain Name**: `frostylabs.local`
**Domain NetBIOS**: `FROSTYLABS`

---

## Lab Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    frostylabs.local Domain                   │
│                   Network: 192.168.139.0/24                  │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐       │
│  │  win-dc01    │  │ win-srv01    │  │ win-srv02    │       │
│  │  DC + DNS    │  │ Member + SQL │  │ Member + IIS │       │
│  │ .139.10      │  │ .139.11      │  │ .139.12      │       │
│  └──────────────┘  └──────────────┘  └──────────────┘       │
│                                                               │
│  ┌──────────────┐  ┌──────────────┐                         │
│  │win-client01  │  │ linux-srv01  │                         │
│  │ Workstation  │  │ LAMP + SSSD  │                         │
│  │ .139.13      │  │ .139.14      │                         │
│  └──────────────┘  └──────────────┘                         │
│                                                               │
└─────────────────────────────────────────────────────────────┘
```

---

## Prerequisites

### Required Software

1. **Vagrant** (2.2.0+)
2. **VMware Workstation/Fusion** or **VirtualBox**
   - This lab uses VMware Desktop provider
3. **Ansible** (2.9+)
   - Windows Ansible modules
   - `ansible.windows` collection
   - `microsoft.ad` collection
4. **Python** (3.8+)
   - `pywinrm` for Windows management

### Install Ansible Collections

```bash
ansible-galaxy collection install ansible.windows
ansible-galaxy collection install microsoft.ad
ansible-galaxy collection install community.windows
```

### Install Python Dependencies

```bash
pip install pywinrm
```

---

## Quick Start

1. **Clone this repository** or navigate to the lab directory:
   ```bash
   cd /path/to/ad-lab
   ```

2. **Update Shared Folder paths** in `Vagrantfile`:
   - Edit line 19 and 131 to match your local shared folder path
   - Currently set to: `E:/VMWare_Storage/Virtual Machines/Shared-Folder`

3. **Provision the VMs**:
   ```bash
   # Start all VMs
   vagrant up

   # Or start VMs individually
   vagrant up win-dc01
   vagrant up win-srv01
   vagrant up win-srv02
   vagrant up win-client01
   vagrant up linsrv1
   ```

4. **Configure network (if needed)**:
   - Windows VMs: Use PowerShell scripts in `Shared-Folder/ps1/`
   - Linux VM: Use script in `Shared-Folder/bash/`

5. **Run Ansible playbooks**:
   ```bash
   # Run all playbooks
   ansible-playbook labsetup.yml

   # Or run individual playbooks
   ansible-playbook playbooks/win-dc01.yml
   ansible-playbook playbooks/win-srv01.yml
   ansible-playbook playbooks/win-srv02.yml
   ansible-playbook playbooks/win-client01.yml
   ansible-playbook playbooks/linux-srv01.yml
   ```

---

## Vagrantfile Configuration

### Global VM Settings

```ruby
config.vm.provider "vmware_desktop" do |v|
  v.gui = true          # Show VM GUI
  v.memory = 4096       # 4GB RAM per VM
  v.cpus = 2            # 2 CPUs per VM
end
```

### Shared Folder Configuration

The Vagrantfile configures a shared folder between your host and guest VMs:

- **Host Path**: `E:/VMWare_Storage/Virtual Machines/Shared-Folder`
- **Guest Path (Windows)**: `C:/Shared-Folder`
- **Guest Path (Linux)**: Disabled (commented out)

**Important**: Update the host path on lines 19 and 131 to match your environment.

### Virtual Machines

#### win-dc01 (Domain Controller)
- **Box**: `StefanScherer/windows_2019`
- **IP**: `192.168.139.10`
- **RDP Port**: `23389` (forwarded from 3389)
- **WinRM Port**: `25985` (forwarded from 5985)
- **Provisioning**: Configures WinRM for Ansible using `ConfigureRemotingForAnsible.ps1`

#### win-srv01 (Member Server + SQL)
- **Box**: `StefanScherer/windows_2019`
- **IP**: `192.168.139.11`
- **RDP Port**: `33389`
- **WinRM Port**: `35985`
- **Provisioning**: WinRM configuration

#### win-srv02 (Member Server)
- **Box**: `StefanScherer/windows_2019`
- **IP**: `192.168.139.12`
- **RDP Port**: `43389`
- **WinRM Port**: `45985`
- **Provisioning**: WinRM configuration

#### win-client01 (Workstation)
- **Box**: `StefanScherer/windows_10`
- **IP**: `192.168.139.13`
- **RDP Port**: `53389`
- **WinRM Port**: `55985`
- **Provisioning**: WinRM configuration

#### linux-srv01 (Linux Server)
- **Box**: `bento/ubuntu-24.04`
- **IP**: `192.168.139.14`
- **SSH Port**: `6222` (forwarded from 22)
- **Shared Folder**: Disabled for Linux VM

---

## Shared Folder

The `Shared-Folder` directory contains scripts and utilities accessible from all VMs.

### Directory Structure

```
Shared-Folder/
├── README.md
├── ps1/                                      # PowerShell scripts
│   ├── 1-configure-ip-dc.ps1                # Configure IP for DC
│   ├── 2-configure-ip-srv01.ps1             # Configure IP for srv01
│   ├── 3-configure-ip-srv02.ps1             # Configure IP for srv02
│   ├── 4-configure-ip-client.ps1            # Configure IP for client
│   └── ConfigureRemotingForAnsible.ps1      # Enable Ansible WinRM
└── bash/                                     # Bash scripts
    └── lin-srv01-eth1.sh                    # Configure IP for Linux
```

### PowerShell Scripts

#### IP Configuration Scripts (1-4)

These scripts configure static IP addresses on the VMs' `Ethernet1` interface:

- Remove existing IP addresses and routes on Ethernet1
- Set static IP address with /24 subnet
- Configure default gateway (192.168.139.1)
- Set DNS servers

**Usage**: Run from within the VM or from Shared-Folder:
```powershell
C:\Shared-Folder\ps1\1-configure-ip-dc.ps1
```

#### ConfigureRemotingForAnsible.ps1

**Purpose**: Configures WinRM (PowerShell Remoting) for Ansible management.

**What it does**:
- Enables WinRM service
- Creates self-signed certificate for HTTPS listener
- Configures WinRM to accept connections
- Opens Windows Firewall for WinRM
- Sets appropriate authentication methods

**Automatic execution**: This script runs automatically during `vagrant up` as a provisioner.

**Security note**: Uses self-signed certificates suitable for lab environments only. Production deployments should use CA-signed certificates and Kerberos authentication.

### Bash Scripts

#### lin-srv01-eth1.sh

Configures static IP addressing for the Linux server's eth1 interface using Netplan.

**Usage**:
```bash
sudo bash /path/to/lin-srv01-eth1.sh
```

---

## Ansible Configuration

### ansible.cfg

Located at the project root, this file contains Ansible runtime configuration:

```ini
[defaults]
inventory = inventory/hosts              # Inventory file location
roles_path = roles                       # Roles directory
host_key_checking = False                # Disable SSH key checking
retry_files_enabled = False              # Disable retry files
deprecation_warnings = False             # Suppress deprecation warnings

[privilege_escalation]
become = False                           # Don't use sudo by default
```

### Inventory Structure

```
inventory/
├── hosts                    # Main inventory file
└── group_vars/
    ├── all.yml             # Variables for all hosts
    ├── win_dc01.yml        # DC-specific variables
    ├── win_srv01.yml       # Server 1 variables
    ├── win_srv02.yml       # Server 2 variables
    ├── win_client01.yml    # Client variables
    └── linux_srv01.yml     # Linux server variables
```

#### inventory/hosts

Defines all lab hosts and groups:

```ini
[win_dc01]
dc01 ansible_host="{{ dc_ip }}"

[win_srv01]
srv01 ansible_host="{{ srv01_ip }}"

[win_srv02]
srv02 ansible_host="{{ srv02_ip }}"

[win_client01]
client01 ansible_host="{{ client_ip }}"

[linux_srv01]
linux-srv01 ansible_host="{{ linux_srv01_ip }}"

[windows:children]
win_dc01
win_srv01
win_srv02
win_client01

[windows:vars]
ansible_user={{ vagrant_user }}
ansible_password={{ vagrant_pass }}
ansible_connection=winrm
ansible_winrm_server_cert_validation=ignore
```

#### inventory/group_vars/all.yml

Global variables shared across all hosts:

**Key variables**:
- **Domain configuration**: `domain`, `domain_netbios`, `domain_dn`
- **IP addresses**: Static IPs for all hosts
- **DNS settings**: Forwarders (8.8.8.8, 8.8.4.4)
- **Credentials**: Administrator, vagrant, and user passwords
- **User accounts**: admin, bob, alice
- **AD Groups**: allTeams, DBAOracle, DBASQLServer, etc.
- **Windows paths**: DNS logs, shares, domain logs
- **LAMP configuration**: Web domain name, paths, Apache settings

**Security note**: This file contains plaintext passwords suitable for lab use only. For production, encrypt with `ansible-vault encrypt inventory/group_vars/all.yml`.

---

## Playbooks

### Main Playbook: labsetup.yml

The master playbook that imports all individual playbooks:

```yaml
---
- import_playbook: playbooks/win-dc01.yml
- import_playbook: playbooks/win-srv01.yml
- import_playbook: playbooks/win-srv02.yml
- import_playbook: playbooks/win-client01.yml
- import_playbook: playbooks/linux-srv01.yml
...
```

**Usage**:
```bash
ansible-playbook labsetup.yml
```

### Individual Playbooks

#### playbooks/win-dc01.yml

Configures the domain controller.

**Roles applied**:
- `common`: Base Windows configuration
- `domain_controller`: AD DS setup and configuration

**Key tasks**:
- Install Chocolatey and common packages
- Set hostname and reboot if needed
- Create AD domain `frostylabs.local`
- Promote to domain controller
- Configure DNS forwarders
- Create domain users (admin, bob, alice)
- Create AD security groups

#### playbooks/win-srv01.yml

Configures first member server with SQL Server.

**Roles applied**:
- `common`: Base Windows configuration
- `member_server`: Domain join and file services
- `mssql`: Microsoft SQL Server installation

**Key tasks**:
- Set hostname
- Configure DNS to point to DC
- Join domain
- Install File Server and IIS management
- Create and share network folders
- Install and configure MS SQL Server

#### playbooks/win-srv02.yml

Configures second member server.

**Roles applied**:
- `common`: Base Windows configuration
- `member_server`: Domain join and file services

**Key tasks**:
- Set hostname
- Configure DNS to point to DC
- Join domain
- Install File Server and IIS management
- Create and share network folders

#### playbooks/win-client01.yml

Configures Windows 10 workstation.

**Roles applied**:
- `commonwkstn`: Base workstation configuration

**Additional tasks**:
- Configure DNS to point to DC
- Create and share network folders
- Join domain
- Add user `bob` to local Administrators group

#### playbooks/linux-srv01.yml

Configures Ubuntu Linux server with AD integration.

**Roles applied**:
- `linux_server_basic`: Base Linux configuration
- `linux_server_domain`: AD/SSSD integration
- `lamp_server`: Apache, MySQL, PHP stack

**Key tasks**:
- Configure timezone and repositories
- Install essential packages
- Join Linux server to AD domain via SSSD
- Install and configure LAMP stack
- Create web virtual host

---

## Roles

### Windows Roles

#### common

**Purpose**: Base configuration for Windows servers.

**Key tasks**:
- Install Chocolatey package manager (version 1.4.0)
- Install common packages:
  - notepadplusplus
  - putty
  - python
  - git
  - 7zip
  - wget
  - pstools
  - sysinternals
- Set hostname
- Configure Administrator account
- Reboot when required

#### commonwkstn

**Purpose**: Base configuration for Windows workstations.

**Key tasks**: Similar to `common` role but tailored for client machines.

#### domain_controller

**Purpose**: Configure Active Directory Domain Services.

**Dependencies**: Requires `common` role.

**Key tasks**:
1. Create AD domain `frostylabs.local`
2. Promote server to domain controller
3. Configure DNS forwarders (8.8.8.8, 8.8.4.4)
4. Create domain users:
   - `admin` (Domain Admin)
   - `bob` (Domain User)
   - `alice` (Domain User)
5. Create AD security groups:
   - allTeams
   - DBAOracle
   - DBASQLServer
   - DBAMongo
   - DBARedis
   - DBAEnterprise
   - JustATestDemo

**Reboots**: Multiple reboots during domain creation and DC promotion.

#### member_server

**Purpose**: Configure member servers and join them to the domain.

**Key tasks**:
1. Set hostname
2. Configure DNS client to use domain controller
3. Install File Server role
4. Install IIS management tools
5. Configure ACLs for machine keys
6. Create public share (`C:\shares\public`)
7. Join domain `frostylabs.local`
8. Reboot after domain join

#### mssql

**Purpose**: Install and configure Microsoft SQL Server.

**Dependencies**: Requires `member_server` role.

**Key tasks**:
- Download SQL Server installation media
- Install SQL Server with custom configuration
- Configure SQL Server service
- Set up database authentication
- Configure firewall rules

### Linux Roles

#### linux_server_basic

**Purpose**: Base configuration for Linux servers.

**Key tasks**:
- Set timezone (Europe/Rome)
- Enable multiverse repository
- Update package cache
- Install essential packages
- Configure hostname
- Set up networking

#### linux_server_domain

**Purpose**: Integrate Linux server with Active Directory.

**Key tasks**:
- Install SSSD (System Security Services Daemon)
- Install Kerberos client
- Configure SSSD for AD authentication
- Join server to `frostylabs.local` domain
- Enable home directory creation for AD users
- Configure PAM for AD authentication

#### lamp_server

**Purpose**: Install and configure Apache, MySQL, PHP stack.

**Key tasks**:
- Install Apache2 web server
- Install MySQL/MariaDB database
- Install PHP and modules
- Create virtual host for `frostylabs`
- Configure web root at `/var/www/frostylabs`
- Set proper permissions for web content
- Enable Apache modules (rewrite, ssl, etc.)

---

## Network Topology

### IP Addressing Scheme

| Hostname      | IP Address      | Role                        | OS               |
|---------------|-----------------|----------------------------|------------------|
| win-dc01      | 192.168.139.10  | Domain Controller + DNS    | Windows Server 2019 |
| win-srv01     | 192.168.139.11  | Member Server + SQL        | Windows Server 2019 |
| win-srv02     | 192.168.139.12  | Member Server + File/IIS   | Windows Server 2019 |
| win-client01  | 192.168.139.13  | Workstation                | Windows 10       |
| linux-srv01   | 192.168.139.14  | LAMP Server + SSSD         | Ubuntu 24.04     |

### Port Forwarding

**RDP Access** (Remote Desktop):
- win-dc01: `localhost:23389`
- win-srv01: `localhost:33389`
- win-srv02: `localhost:43389`
- win-client01: `localhost:53389`

**WinRM Access** (Ansible):
- win-dc01: `localhost:25985`
- win-srv01: `localhost:35985`
- win-srv02: `localhost:45985`
- win-client01: `localhost:55985`

**SSH Access**:
- linux-srv01: `localhost:6222`

### Network Services

- **DNS Server**: win-dc01 (192.168.139.10)
- **Domain Controller**: win-dc01 (192.168.139.10)
- **SQL Server**: win-srv01 (192.168.139.11)
- **Web Server**: linux-srv01 (192.168.139.14)

---

## Usage

### Connecting to VMs

#### RDP to Windows VMs

```bash
# From your host machine
mstsc /v:localhost:23389    # Domain Controller
mstsc /v:localhost:33389    # Server 01
mstsc /v:localhost:43389    # Server 02
mstsc /v:localhost:53389    # Client 01
```

Or use any RDP client:
- **Host**: `localhost`
- **Port**: See port forwarding table above
- **Username**: `vagrant` or `Administrator@frostylabs.local`
- **Password**: `vagrant` or `StrongPass123!`

#### SSH to Linux VM

```bash
vagrant ssh linux-srv01

# Or via SSH client
ssh -p 6222 vagrant@localhost
# Password: vagrant
```

#### Using Vagrant Commands

```bash
# Check VM status
vagrant status

# Start specific VM
vagrant up win-dc01

# Restart VM
vagrant reload win-srv01

# Suspend VM
vagrant suspend win-client01

# Resume VM
vagrant resume win-client01

# Stop VM
vagrant halt linux-srv01

# Destroy VM
vagrant destroy win-srv02

# SSH into VM (Linux only)
vagrant ssh linux-srv01

# RDP into Windows VM
vagrant rdp win-dc01
```

### Running Ansible

#### Check Connectivity

```bash
# Ping all Windows hosts
ansible windows -m win_ping

# Ping specific host
ansible win_dc01 -m win_ping

# Ping Linux host
ansible linux_srv01 -m ping
```

#### Run Playbooks

```bash
# Run all playbooks in order
ansible-playbook labsetup.yml

# Run specific playbook
ansible-playbook playbooks/win-dc01.yml

# Run with verbose output
ansible-playbook labsetup.yml -v

# Run with specific inventory
ansible-playbook -i inventory/hosts playbooks/win-srv01.yml
```

#### Ad-hoc Commands

```bash
# Get hostname from all Windows hosts
ansible windows -m win_shell -a "hostname"

# Check domain membership
ansible win_srv01 -m win_shell -a "systeminfo | findstr Domain"

# Reboot all Windows servers
ansible windows -m win_reboot

# Run command on Linux server
ansible linux_srv01 -m shell -a "hostname"
```

### Default Credentials

#### Domain Accounts

| Username      | Password         | Role                     |
|---------------|------------------|--------------------------|
| Administrator | StrongPass123!   | Domain Administrator     |
| admin         | StrongPass123!   | Domain Administrator     |
| bob           | StrongPass123!   | Domain User + Local Admin on client |
| alice         | StrongPass123!   | Domain User              |

#### Local Accounts

| Username  | Password  | Where                |
|-----------|-----------|----------------------|
| vagrant   | vagrant   | All VMs (local admin)|

---

## Troubleshooting

### Vagrant Issues

**VMs won't start**:
```bash
# Check Vagrant status
vagrant status

# Check VMware is running
vagrant plugin list

# Reload VM
vagrant reload <vm-name>
```

**Shared folder not mounting**:
- Verify the path in Vagrantfile (lines 19, 131) exists on your host
- Ensure VMware Tools is installed in the guest
- Try `vagrant reload <vm-name>` to remount

**Network issues**:
- Verify VMware network adapter is configured
- Check firewall settings on host
- Use the IP configuration scripts in `Shared-Folder/`

### Ansible Issues

**Cannot connect to Windows hosts**:
```bash
# Test WinRM connectivity
ansible win_dc01 -m win_ping -vvv

# Verify WinRM is configured
# RDP to the VM and run:
winrm quickconfig
```

**Authentication failures**:
- Check credentials in `inventory/group_vars/all.yml`
- Ensure the ConfigureRemotingForAnsible.ps1 script ran during provisioning
- Verify time sync between Ansible controller and Windows hosts

**Error with an individual the playbook**:
- Run them singularly with `ansible playbooks/[host causing issues].yml` and go from there

**Module not found**:
```bash
# Install required collections
ansible-galaxy collection install ansible.windows
ansible-galaxy collection install microsoft.ad
ansible-galaxy collection install community.windows
```

**Python WinRM errors**:
```bash
# Install/update pywinrm
pip install --upgrade pywinrm
```

### Domain Issues

**Domain join fails**:
- Ensure the domain controller (win-dc01) is fully configured first
- Verify DNS is pointing to the DC (192.168.139.10)
- Check domain credentials in group_vars
- Wait a few minutes after DC promotion before joining members

**DNS resolution issues**:
- Verify DNS server on each VM points to 192.168.139.10
- Use the IP configuration scripts to set DNS
- Check DNS forwarders are configured on DC

**Time synchronization**:
```bash
# On Windows VMs
w32tm /resync

# On Linux VMs
sudo ntpdate -u 192.168.139.10
```

### SQL Server Issues

**SQL Server not accessible**:
- Check SQL Server service is running
- Verify firewall rules allow SQL traffic
- Ensure SQL Server authentication is configured
- Check SQL Server logs in `C:\Program Files\Microsoft SQL Server\`

---

## Additional Notes

### Lab Purpose

This lab is designed for:
- Active Directory administration practice
- Penetration testing and security research
- Learning Ansible automation for Windows environments
- Testing cross-platform domain integration
- Developing and testing enterprise applications

### Security Warnings

This lab uses insecure configurations suitable for isolated lab environments only:

- Plaintext passwords in configuration files
- Self-signed certificates
- Disabled certificate validation
- Weak passwords (easily guessable)
- Disabled host key checking

**Do not expose this lab to production networks or the internet.**

### Customization

To customize this lab:

1. **Change domain name**: Edit `domain` in `inventory/group_vars/all.yml`
2. **Add more users**: Add entries to playbooks or roles
3. **Modify IP addresses**: Update Vagrantfile and group_vars
4. **Add more VMs**: Add new VM definitions to Vagrantfile
5. **Install additional software**: Extend roles or create new ones

### Performance Tips

- **Memory**: Ensure your host has enough RAM (recommended: 16GB+)
- **CPU**: More cores = better performance
- **Storage**: SSDs significantly improve VM performance
- **Snapshots**: Take snapshots after successful provisioning for quick recovery

### Cleanup

```bash
# Stop all VMs
vagrant halt

# Destroy all VMs (cannot be undone!)
vagrant destroy -f

# Remove Vagrant boxes (optional)
vagrant box remove StefanScherer/windows_2019
vagrant box remove StefanScherer/windows_10
vagrant box remove bento/ubuntu-24.04
```

---


## Contributing

Feel free to submit issues or pull requests for improvements.

---

**Happy Labbing!**
