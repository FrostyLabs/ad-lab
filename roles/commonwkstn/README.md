# Common Workstation Role

## Description

This role configures baseline settings for Windows workstations in the AD lab environment, including keyboard layout, Remote Desktop access, hostname configuration, and essential software packages.

## What This Role Does

1. **Regional Settings**
   - Configures Swiss German keyboard layout (de-CH)
   - Sets keyboard input method to Swiss German (0807:00000807)

2. **PowerShell Module Installation**
   - Installs NuGet package provider with TLS 1.2
   - Installs xRemoteDesktopAdmin PowerShell module for RDP management
   - Installs xNetworking PowerShell module for firewall configuration

3. **Remote Access Configuration**
   - Enables Remote Desktop with Secure (NLA) authentication
   - Configures Windows Firewall to allow RDP on port 3389 (Domain profile)

4. **Hostname Configuration**
   - Sets the computer hostname to the value defined in `client_hostname` variable
   - Automatically reboots the system if hostname change requires it

5. **Package Management**
   - Installs Chocolatey package manager (specific version)
   - Installs chocolatey-core.extension for enhanced functionality

6. **Software Installation**
   - Notepad++ (text editor)
   - Git (version control)
   - PSTools (Sysinternals utilities)

## Requirements

- Windows 10/11 or Windows Server
- PowerShell 5.0 or later
- Internet connectivity for downloading packages

## Key Variables

```yaml
client_hostname: WKSTN01           # Hostname to set for the workstation
chocolatey_version: "1.2.0"        # Specific version of Chocolatey to install
```

## Example Playbook

```yaml
- name: Configure Windows workstation
  hosts: workstations
  vars:
    client_hostname: CLIENT01
  roles:
    - commonwkstn
```

## Notes

- The role will automatically reboot if the hostname change requires it
- Chocolatey is installed with a specific version for consistency
- Remote Desktop is configured with Network Level Authentication (NLA) for security
- Swiss German keyboard layout is configured for the lab environment locale

## Installed Software

| Package | Description |
|---------|-------------|
| notepadplusplus | Advanced text editor |
| git | Distributed version control system |
| pstools | Sysinternals command-line utilities |

## Dependencies

None
