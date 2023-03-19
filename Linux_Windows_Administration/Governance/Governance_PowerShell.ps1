# Set Azure Subscription and Resource Group
$SubscriptionName = "MySubscription"
$ResourceGroupName = "MyResourceGroup"
Set-AzContext -Subscription $SubscriptionName
New-AzResourceGroup -Name $ResourceGroupName -Location "East US"

# Create Virtual Network and Subnet
$VNetName = "MyVNet"
$SubnetName = "MySubnet"
$VNet = New-AzVirtualNetwork -ResourceGroupName $ResourceGroupName -Location "East US" -Name $VNetName -AddressPrefix 10.0.0.0/16
$Subnet = Add-AzVirtualNetworkSubnetConfig -Name $SubnetName -VirtualNetwork $VNet -AddressPrefix 10.0.0.0/24
Set-AzVirtualNetwork -VirtualNetwork $VNet

# Create Network Security Group and Rule
$NSGName = "MyNSG"
$RuleName = "Allow-RDP"
$NSG = New-AzNetworkSecurityGroup -Name $NSGName -ResourceGroupName $ResourceGroupName -Location "East US"
$RDP = New-AzNetworkSecurityRuleConfig -Name $RuleName -Protocol Tcp -Direction Inbound -Priority 1000 -SourceAddressPrefix * -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 3389 -Access Allow
$NSG | Add-AzNetworkSecurityRuleConfig -Name $RuleName -Direction Inbound -Priority 1000 -Protocol TCP -SourceAddressPrefix * -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 3389 -Access Allow
Set-AzNetworkSecurityGroup -NetworkSecurityGroup $NSG

# Create Virtual Machine
$VMName = "MyVM"
$Username = "MyUser"
$Password = ConvertTo-SecureString "MyPassword1234!" -AsPlainText -Force
$VMConfig = New-AzVMConfig -VMName $VMName -VMSize "Standard_B1s" | Set-AzVMOperatingSystem -Windows -ComputerName $VMName -Credential (New-Object System.Management.Automation.PSCredential ($Username, $Password))
$VMConfig = $VMConfig | Add-AzVMNetworkInterface -Id $Subnet.Id -Primary
$VMConfig = $VMConfig | Set-AzVMOSDisk -CreateOption FromImage -Windows
New-AzVM -ResourceGroupName $ResourceGroupName -Location "East US" -VM $VMConfig

# Configure DNS Server
$DNSIP = "10.0.0.4"
Set-DnsClientServerAddress -InterfaceIndex (Get-NetAdapter).InterfaceIndex -ServerAddresses $DNSIP

# Configure Firewall
New-NetFirewallRule -DisplayName "Allow RDP" -Direction Inbound -Protocol TCP -LocalPort 3389 -Action Allow

# Create User Account with Remote Desktop Access
$NewUser = New-LocalUser -Name $Username -Password $Password -FullName $Username
$Group = "Remote Desktop Users"
Add-LocalGroupMember -Group $Group -Member $Username

# Add user to Local Administrators group
Add-LocalGroupMember -Group "Administrators" -Member $Username
