# Execute privileged
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Start-Process powershell.exe "-ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

# Clear old IPv4 addresses on Ethernet1
$oldIPs = Get-NetIPAddress -InterfaceAlias "Ethernet1" -AddressFamily IPv4 -ErrorAction SilentlyContinue
if ($oldIPs) {
    $oldIPs | Remove-NetIPAddress -Confirm:$false
}

# Clear existing default routes (gateways) on Ethernet1
$oldRoutes = Get-NetRoute -InterfaceAlias "Ethernet1" -DestinationPrefix "0.0.0.0/0" -ErrorAction SilentlyContinue
if ($oldRoutes) {
    $oldRoutes | Remove-NetRoute -Confirm:$false
}

# Apply new IP configuration
New-NetIPAddress `
    -InterfaceAlias "Ethernet1" `
    -IPAddress "192.168.139.11" `
    -PrefixLength 24 `
    -DefaultGateway "192.168.139.1"

# Set DNS servers (change/add as needed)
Set-DnsClientServerAddress `
    -InterfaceAlias "Ethernet1" `
    -ServerAddresses @("192.168.139.10","1.1.1.1")
