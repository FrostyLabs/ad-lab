# MSSQL Role

## Description

This role installs and configures Microsoft SQL Server 2017 Developer Edition on Windows servers within an Active Directory domain environment. It handles the complete setup from prerequisites through to SQL Server Management Studio installation.

The role is adapted from [kkolk/mssql](https://github.com/kkolk/mssql) and has been customized for this AD lab environment.

## What This Role Does

1. **Prerequisites Installation**
   - Installs .NET Framework (Core, 3.5, and 4.5+ features)
   - Installs .NET Framework 4.8
   - Installs NuGet provider and required PowerShell modules (SQLServerDsc, StorageDsc, dbatools, xNetworking)
   - Installs Windows Process Activation Service

2. **Service Account Creation**
   - Creates SQL Service account in Active Directory
   - Creates SQL Agent Service account in Active Directory
   - Delegates these tasks to the domain controller

3. **SQL Server Installation**
   - Downloads SQL Server 2017 Developer Edition installation media
   - Extracts installation files
   - Installs SQL Server with configured features using PowerShell DSC
   - Configures database and log file paths

4. **Network Configuration**
   - Enables TCP/IP protocol for SQL Server
   - Configures SQL Server to listen on specified port (default: 1433)
   - Configures Windows Firewall rules for Database Engine and SQL Browser

5. **Performance Tuning**
   - Sets maximum and minimum server memory allocation
   - Configures max degree of parallelism

6. **Management Tools**
   - Installs Chocolatey package manager
   - Installs SQL Server Management Studio (SSMS) via Chocolatey

7. **Database Setup**
   - Copies database creation scripts to the server

## Requirements

- PowerShell 5.0 / WMF 5.1 on target host
- Windows Server (2012 R2 or later recommended)
- Active Directory domain environment
- Domain controller accessible for service account creation

## Key Variables

See `defaults/main.yml` for all configurable options. Key variables include:

```yaml
# SQL Server instance configuration
mssql_instance_name: Test
mssql_port: 1433
mssql_features: SQLENGINE,FULLTEXT,CONN

# Memory configuration (in MB)
mssql_max_server_memory: 1024
mssql_min_server_memory: 0

# Service accounts (created in AD)
mssql_sqlsvc_account: DOMAIN\sql_svc
mssql_agentsvc_account: DOMAIN\sql_agt

# Installation paths
mssql_installation_path: C:\SQLInstall
mssql_instance_path: C:\Program Files\Microsoft SQL Server\Test
```

## Example Playbook

```yaml
- name: Configure SQL Server
  hosts: win_srv01
  roles:
    - mssql
```

## Notes

- Installation logs are located at: `C:\Program Files\Microsoft SQL Server\...\Setup Bootstrap\Log`
- The role uses PowerShell DSC for SQL installation and configuration
- SSMS installation may take significant time and will poll every 2 minutes for completion status
- Service accounts are created with passwords that never expire

## Troubleshooting

If SQL Server installation fails:
1. Check setup logs in `C:\Program Files\Microsoft SQL Server\...\Setup Bootstrap\Log`
2. Review DSC logs: https://docs.microsoft.com/en-us/powershell/dsc/troubleshooting
3. Ensure service account credentials are correct
4. Verify no pending reboots exist before installation

## License

BSD / MIT

## Author Information

Original: Kevin Kolk - http://www.frostbyte.us
Modified for AD lab environment
