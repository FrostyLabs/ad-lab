# Member Server Role

## Description

This role configures a Windows Server as a domain member server with file services and IIS management capabilities. It handles hostname configuration, DNS setup, feature installation, and domain joining.

## What This Role Does

1. **Hostname Configuration**
   - Sets the server hostname to the configured value
   - Reboots if hostname change requires it

2. **DNS Client Configuration**
   - Configures all network adapters to use the domain controller as DNS server
   - Points to DC for domain name resolution

3. **File Services Installation**
   - Installs File Server role (File-Services)
   - Installs File Server resource manager (FS-FileServer)
   - Includes management tools

4. **IIS Management Tools**
   - Installs IIS management console (Web-Mgmt-Console)
   - Installs IIS scripting tools (Web-Scripting-Tools)
   - Installs IIS management service (Web-Mgmt-Service)

5. **IIS Legacy Compatibility**
   - Installs IIS 6 compatibility features
   - Installs Metabase compatibility (Web-Metabase)
   - Installs legacy management console and scripting
   - Installs WMI compatibility (Web-WMI)

6. **Security Configuration**
   - Configures SYSTEM account permissions on machine keys directory
   - Sets FullControl rights for cryptographic operations

7. **File Sharing**
   - Creates shared directory for public access
   - Configures SMB share named "public"
   - Sets permissions: Full control for Administrators, Change for Users
   - Makes share visible in network browsing

8. **Domain Membership**
   - Joins the server to the Active Directory domain
   - Uses domain admin credentials for join operation
   - Reboots after successful domain join

## Requirements

- Windows Server 2012 R2 or later
- Network connectivity to domain controller
- Domain controller must be accessible and functioning
- Microsoft.AD Ansible collection

## Key Variables

```yaml
srv_hostname: SRV01                            # Server hostname
dc_ip: 192.168.1.10                            # Domain controller IP address
domain: example.local                          # AD domain name
domain_admin_user_fqn: Administrator@example.local  # Domain admin UPN
Administrator_pass: ComplexP@ssw0rd            # Domain admin password
win_dns_log_path: C:\ansible_dns_log.txt       # DNS configuration log path
win_shares_path: C:\Shares\Public              # Path for shared directory
```

## Example Playbook

```yaml
- name: Configure member server
  hosts: win_srv01
  vars:
    srv_hostname: SRV01
    dc_ip: 192.168.1.100
    domain: lab.local
  roles:
    - member_server
```

## Notes

- The role will reboot the server twice:
  - Once after hostname change (if needed)
  - Once after domain join
- DNS must point to the domain controller before domain join
- The public share is configured with relatively open permissions (suitable for lab environments)
- IIS management tools are installed but IIS web server itself is not installed
- Machine keys permissions are configured to support IIS and certificate operations

## Created Resources

After running this role:
- Server is joined to the domain
- File Server role is installed and ready
- IIS management tools available (but web server not installed)
- Public file share available at `\\<hostname>\public`
- DNS configured to use domain controller

## Security Considerations

This role is designed for lab environments:
- The public share grants Change permissions to all domain Users
- Share is visible in network browsing
- No access-based enumeration configured
- For production, implement more restrictive permissions

## Dependencies

- `microsoft.ad` Ansible collection must be installed
- Domain controller must be provisioned and accessible
