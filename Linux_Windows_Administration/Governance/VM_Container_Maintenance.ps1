# Connect to Azure account
Connect-AzAccount

# Create a new resource group for virtual machines
$RGName = "MyVMRG"
$Location = "East US"
New-AzResourceGroup -Name $RGName -Location $Location

# Create a new virtual network for virtual machines
$VNetName = "MyVMVNet"
$VNetPrefix = "10.0.0.0/16"
$SubnetName = "MyVMSubnet"
$SubnetPrefix = "10.0.0.0/24"
$VNet = New-AzVirtualNetwork -Name $VNetName -ResourceGroupName $RGName -Location $Location -AddressPrefix $VNetPrefix
$Subnet = Add-AzVirtualNetworkSubnetConfig -Name $SubnetName -VirtualNetwork $VNet -AddressPrefix $SubnetPrefix
$VNet | Set-AzVirtualNetwork

# Create a new virtual machine
$VMName = "MyVM"
$VMSize = "Standard_B1s"
$AdminUsername = "adminuser"
$AdminPassword = ConvertTo-SecureString "P@ssw0rd!" -AsPlainText -Force
$OSDiskName = $VMName + "_OSDisk"
$NICName = $VMName + "_NIC"
$IPAddress = "10.0.0.4"
$VM = New-AzVMConfig -VMName $VMName -VMSize $VMSize
$VM = Set-AzVMOperatingSystem -VM $VM -Windows -ComputerName $VMName -Credential (New-Object System.Management.Automation.PSCredential ($AdminUsername, $AdminPassword)) -ProvisionVMAgent -EnableAutoUpdate
$VM = Add-AzVMNetworkInterface -VM $VM -Id $Subnet.Id -Primary
$VM = Set-AzVMSourceImage -VM $VM -PublisherName MicrosoftWindowsServer -Offer WindowsServer -Skus 2019-Datacenter -Version latest
$VM = Set-AzVMOSDisk -VM $VM -Name $OSDiskName -CreateOption FromImage -Caching ReadWrite -ManagedDiskId $null -DiskSizeGB 128 -StorageAccountType Standard_LRS
New-AzVM -ResourceGroupName $RGName -Location $Location -VM $VM

# Create a new container
$ContainerName = "mycontainer"
$ImageName = "nginx"
$ContainerPort = 80
$Container = New-AzContainerGroup -ResourceGroupName $RGName -Name $ContainerName -Location $Location -Image $ImageName -OsType Linux -DnsNameLabel $ContainerName -Ports $ContainerPort
