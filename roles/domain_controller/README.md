# Domain Controller Role

## Description

This role provisions and configures a Windows Server as an Active Directory Domain Controller. It handles the complete setup from initial software installation through domain creation, DC promotion, DNS configuration, and creation of initial users and groups.

## What This Role Does

1. **Software Installation**
   - Installs Chocolatey package manager and core extensions
   - Disables Chocolatey enhanced exit codes for compatibility
   - Installs essential tools: Notepad++, PuTTY, Python, Git, 7-Zip, wget, PSTools, Sysinternals

2. **Hostname Configuration**
   - Sets the server hostname to the configured DC hostname
   - Reboots if hostname change requires it

3. **Administrator Account Configuration**
   - Configures the built-in Administrator account with specified password
   - Sets password to never expire

4. **Active Directory Domain Setup**
   - Creates new AD forest and domain
   - Configures Directory Services Restore Mode (DSRM) password
   - Reboots after domain creation

5. **Domain Controller Promotion**
   - Promotes the server to domain controller
   - Configures domain log paths
   - Reboots after DC promotion

6. **DNS Configuration**
   - Installs xDnsServer PowerShell module
   - Configures DNS forwarders for external name resolution
   - Enables recursion for DNS queries

7. **User Creation**
   - Creates domain admin user (with Domain Admins group membership)
   - Creates standard domain users (Bob and Alice)
   - Sets all user passwords to never expire
   - Places users in configured OU structure

8. **Group Creation**
   - Creates configured AD security groups
   - Sets group scope to global

## Requirements

- Windows Server 2012 R2 or later
- PowerShell 5.0 or later
- Microsoft.AD Ansible collection
- Internet connectivity for package downloads

## Key Variables

```yaml
dc_hostname: DC01                              # Domain controller hostname
domain: example.local                          # AD domain name
domain_admin_user: Administrator               # Domain admin username
domain_admin_user_fqn: Administrator@example.local
Administrator_pass: ComplexP@ssw0rd            # Administrator password
safe_mode_password: DSRM_P@ssw0rd              # DSRM password
dns_forwarders: ['8.8.8.8', '8.8.4.4']        # DNS forwarders
users_ou: CN=Users,DC=example,DC=local         # Users OU path
base_ou: DC=example,DC=local                   # Base OU for groups

# Additional users
admin_user: admin
admin_pass: P@ssw0rd
bob_user: bob
bob_pass: P@ssw0rd
alice_user: alice
alice_pass: P@ssw0rd

# AD groups to create
ad_groups:
  - IT Staff
  - Finance
  - HR
```

## Example Playbook

```yaml
- name: Setup Domain Controller
  hosts: dc
  vars:
    domain: lab.local
    dc_hostname: DC01
  roles:
    - domain_controller
```

## Notes

- This role will reboot the server multiple times during execution
- The first reboot occurs after hostname change (if needed)
- The second reboot occurs after domain creation
- The third reboot occurs after DC promotion
- DNS forwarders are configured to allow resolution of external domains
- All created user passwords are set to never expire (for lab use only)
- Directory Services Restore Mode password is required for AD recovery scenarios

## Post-Installation

After running this role, you will have:
- A functioning Active Directory domain
- DNS services running on the DC
- Three domain users (admin with Domain Admins privileges, bob and alice as standard users)
- Configured security groups
- Common administrative tools installed

## Security Considerations

This role is designed for lab environments and uses simplified security settings:
- Passwords never expire
- Simple password complexity (should be changed for production)
- No fine-grained password policies
- Default AD security settings

## Dependencies

- `microsoft.ad` Ansible collection must be installed
