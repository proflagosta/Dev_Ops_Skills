# Install DNS Server role
Install-WindowsFeature -Name DNS -IncludeManagementTools

# Configure the DNS server to use Google's public DNS servers for upstream resolution
$dnsServers = @("8.8.8.8", "8.8.4.4")
Set-DnsServerForwarder -IPAddress $dnsServers

#git add SetupDnsServer.ps1
#git commit -m "Add script to set up a DNS server on Windows Server"
#git push origin main
