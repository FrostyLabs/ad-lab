# Linux Server Basic Role

## Description

This role provides basic configuration for Ubuntu/Debian Linux servers that will integrate with Active Directory. It handles timezone configuration, repository setup, system updates, and installation of essential packages for AD domain integration.

## What This Role Does

1. **Timezone Configuration**
   - Sets system timezone to the configured value
   - Ensures consistent time across the infrastructure

2. **Repository Management**
   - Adds the multiverse repository for access to additional packages
   - Uses apt-add-repository to configure sources

3. **System Updates**
   - Updates APT package cache
   - Upgrades all installed packages to latest versions
   - Ensures system is up-to-date before domain integration

4. **Domain Integration Tools**
   - Installs Kerberos client (krb5-user) for AD authentication
   - Installs Chrony for time synchronization
   - Installs Python 3 pip package manager
   - Installs Realmd for AD domain discovery and joining
   - Installs SSSD (System Security Services Daemon) and tools
   - Installs NSS and PAM modules for SSSD integration
   - Installs Adcli for AD administrative tasks
   - Installs Samba common binaries
   - Installs Oddjob for dynamic system tasks
   - Installs Oddjob-mkhomedir for automatic home directory creation
   - Installs PackageKit for package management integration

5. **Python Dependencies**
   - Installs pexpect Python module for automated interactive tasks
   - Required for domain join automation

## Requirements

- Ubuntu/Debian-based Linux distribution (Ubuntu 18.04+ or Debian 10+ recommended)
- Sudo/root access
- Internet connectivity for package downloads
- Network connectivity to Active Directory domain controller (for domain operations)

## Key Variables

```yaml
timezone: Europe/Zurich                        # System timezone to configure
apt_repository: multiverse                     # APT repository to add
```

## Example Playbook

```yaml
- name: Configure Linux server basics
  hosts: linux_servers
  become: yes
  vars:
    timezone: America/New_York
  roles:
    - linux_server_basic
```

## Notes

- This role prepares the system for AD integration but does not join the domain
- Use the `linux_server_domain` role after this role to complete domain joining
- All package installations run with elevated privileges
- System packages are upgraded during this role execution
- Kerberos configuration may prompt for realm information during package installation

## Installed Packages

### Authentication & Domain Integration
- `krb5-user` - Kerberos authentication client
- `realmd` - Active Directory domain discovery and enrollment
- `sssd`, `sssd-tools` - System Security Services Daemon
- `libnss-sss` - NSS module for SSSD
- `libpam-sss` - PAM module for SSSD
- `adcli` - Active Directory enrollment helper

### Supporting Tools
- `chrony` - NTP client for time synchronization
- `python3-pip` - Python package manager
- `samba-common-bin` - Samba utilities
- `oddjob`, `oddjob-mkhomedir` - Dynamic system task execution
- `packagekit` - Package management abstraction layer

## Time Synchronization

The role installs Chrony for NTP time synchronization. Accurate time is critical for Kerberos authentication in AD environments. You may need to configure Chrony to sync with your domain controller or other time sources.

## Dependencies

None - this is typically the first role applied to Linux servers in the AD lab environment.
