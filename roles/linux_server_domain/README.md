# Linux Server Domain Role

## Description

This role joins a Linux server to an Active Directory domain and configures the system for AD authentication. It handles DNS configuration, hostname setup, domain enrollment, and PAM configuration for automatic home directory creation.

## What This Role Does

1. **DNS Configuration**
   - Deploys systemd-resolved configuration from template
   - Points DNS to the Active Directory domain controller
   - Ensures proper domain name resolution for AD operations
   - Registers configuration change for reboot trigger

2. **Hostname Configuration**
   - Sets the system hostname to the configured value
   - Updates /etc/hostname file
   - Registers configuration change for reboot trigger

3. **System Reboot**
   - Reboots the system if DNS or hostname configuration changed
   - Ensures clean state before domain join operations

4. **Domain Join Check**
   - Uses `realm list` to check current domain membership status
   - Prevents duplicate join attempts if already domain-joined

5. **Domain Enrollment**
   - Joins the server to the Active Directory domain using `realm join`
   - Uses `expect` module for automated credential entry
   - Provides domain admin credentials for join operation
   - Only executes if not already domain-joined

6. **PAM Configuration**
   - Deploys custom PAM configuration for common-account
   - Enables automatic home directory creation on first login
   - Allows AD users to authenticate to the Linux system

## Requirements

- Ubuntu/Debian-based Linux system
- `linux_server_basic` role applied first (installs required packages)
- Network connectivity to Active Directory domain controller
- DNS resolution to domain controller
- Domain admin credentials
- Required packages installed: realmd, sssd, pexpect

## Key Variables

```yaml
linux_srv01_hostname: LINUX01                # Linux server hostname
domain: example.local                          # AD domain name
domain_admin_user: Administrator               # Domain admin username
Administrator_pass: ComplexP@ssw0rd            # Domain admin password
```

## Template Files

The role requires these template files in `templates/`:
- `resolved.conf.j2` - systemd-resolved DNS configuration template
- Should configure DNS servers pointing to domain controller

The role requires these files in `files/`:
- `common-account` - PAM configuration for account management
- Enables automatic home directory creation

## Example Playbook

```yaml
- name: Join Linux server to domain
  hosts: linux_servers
  become: yes
  vars:
    linux_srv01_hostname: UBUNTU01
    domain: lab.local
    domain_admin_user: Administrator
    Administrator_pass: P@ssw0rd123
  roles:
    - linux_server_basic    # Run this first
    - linux_server_domain   # Then run this
```

## Notes

- This role should be run after `linux_server_basic` role
- The role will reboot the system if DNS or hostname configuration changes
- Domain join is idempotent - will not attempt to rejoin if already member
- The `expect` module is used to automate the interactive `realm join` command
- After successful join, AD users can authenticate to the Linux system
- Home directories are created automatically on first login

## Domain Join Process

1. Configure DNS to point to domain controller
2. Set appropriate hostname
3. Reboot to apply network changes
4. Check if already domain-joined
5. If not joined, execute `realm join` with admin credentials
6. Configure PAM for automatic home directory creation

## Post-Installation

After running this role, you can:
- Authenticate as AD users: `su - username@domain.local`
- View domain information: `realm list`
- Check SSSD status: `systemctl status sssd`
- View domain users: `id username@domain.local`

## Troubleshooting

If domain join fails:
1. Verify DNS resolution: `nslookup domain.local`
2. Check network connectivity to DC
3. Verify domain admin credentials
4. Check Kerberos configuration: `kinit administrator@DOMAIN.LOCAL`
5. Review SSSD logs: `/var/log/sssd/`
6. Check realm discovery: `realm discover domain.local`

## Security Considerations

- Domain admin credentials are used for join operation
- Consider using a dedicated account with limited privileges for domain joins
- PAM configuration allows all domain users to authenticate (implement access restrictions as needed)
- Home directories are created with default permissions

## Dependencies

- `linux_server_basic` role must be applied first
- Python pexpect module (installed by linux_server_basic)
- systemd-resolved for DNS management
