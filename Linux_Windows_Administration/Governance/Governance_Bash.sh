# Install Windows Feature
Install-WindowsFeature -Name AD-Domain-Services

# Configure DNS Server
$IP = "192.168.1.10"
$Subnet = "255.255.255.0"
$Gateway = "192.168.1.1"
$DNS = "127.0.0.1"
New-NetIPAddress -IPAddress $IP -PrefixLength 24 -InterfaceIndex 12
Set-DnsClientServerAddress -InterfaceIndex 12 -ServerAddresses $DNS
Set-NetIPInterface -InterfaceIndex 12 -InterfaceMetric 2
Set-NetIPAddress -IPAddress $IP -PrefixLength 24 -DefaultGateway $Gateway

# Create a New User Account
$UserName = "JohnDoe"
$Password = "Passw0rd!"
New-LocalUser -Name $UserName -Password (ConvertTo-SecureString $Password -AsPlainText -Force) -Description "John Doe Account"

# Set up Remote Desktop
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -name "fDenyTSConnections" -Value 0 #allows RD connections
Enable-NetFirewallRule -DisplayGroup "Remote Desktop"

# Configure Firewall
New-NetFirewallRule -DisplayName "Allow Remote Desktop" -Direction Inbound -Protocol TCP -LocalPort 3389 -Action Allow
New-NetFirewallRule -DisplayName "Allow DNS" -Direction Inbound -Protocol UDP -LocalPort 53 -Action Allow
New-NetFirewallRule -DisplayName "Allow HTTP" -Direction Inbound -Protocol TCP -LocalPort 80 -Action Allow
New-NetFirewallRule -DisplayName "Allow HTTPS" -Direction Inbound -Protocol TCP -LocalPort 443 -Action Allow

# Add JohnDoe user to Local Administrators group
Add-LocalGroupMember -Group "Administrators" -Member $UserName
