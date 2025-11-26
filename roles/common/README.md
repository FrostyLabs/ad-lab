# Common Role

## Description

This role provides common baseline configuration for Windows servers in the AD lab environment. It handles DSC cleanup, keyboard layout configuration, and Remote Desktop setup.

## What This Role Does

1. **DSC State Management**
   - Stops any stuck DSC operations
   - Cleans up DSC configuration files (Current.mof, Pending.mof, Previous.mof, etc.)
   - Restarts WMI service to clear DSC state
   - Ensures clean state for subsequent DSC operations

2. **Regional Settings**
   - Configures Swiss German keyboard layout (de-CH)
   - Sets keyboard input method to Swiss German (0807:00000807)

3. **PowerShell Module Installation**
   - Installs NuGet package provider with TLS 1.2
   - Installs xRemoteDesktopAdmin PowerShell module
   - Installs xNetworking PowerShell module

4. **Remote Access Configuration**
   - Enables Remote Desktop with Secure (NLA) authentication
   - Configures Windows Firewall to allow RDP traffic on port 3389
   - Applies firewall rule to Domain profile

## Requirements

- Windows Server (2012 R2 or later)
- PowerShell 5.0 or later
- Internet connectivity for downloading PowerShell modules

## Variables

This role uses minimal variables. Regional and security settings are hardcoded for consistency across the lab environment.

## Example Playbook

```yaml
- name: Apply common Windows server configuration
  hosts: windows_servers
  roles:
    - common
```

## Notes

- This role should typically be applied before other roles that use PowerShell DSC
- The DSC cleanup tasks help prevent conflicts from previous failed DSC operations
- Swiss German keyboard layout is configured for the lab environment locale
- Remote Desktop is configured with Network Level Authentication (NLA) for security

## Dependencies

None
