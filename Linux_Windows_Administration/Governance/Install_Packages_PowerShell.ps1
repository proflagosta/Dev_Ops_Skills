# Create Resource Group and Virtual Machine
$ResourceGroupName = "MyResourceGroup"
$Location = "East US"
$VMName = "MyVM"
$VMSize = "Standard_B1s"
$ImagePublisher = "MicrosoftWindowsServer"
$ImageOffer = "WindowsServer"
$ImageSKU = "2019-Datacenter"
$Username = "MyUser"
$Password = ConvertTo-SecureString "MyPassword1234!" -AsPlainText -Force

New-AzResourceGroup -Name $ResourceGroupName -Location $Location
$Credential = New-Object System.Management.Automation.PSCredential ($Username, $Password)
$VMConfig = New-AzVMConfig -VMName $VMName -VMSize $VMSize
$VMConfig = Set-AzVMOperatingSystem -VM $VMConfig -Windows -ComputerName $VMName -Credential $Credential -ProvisionVMAgent -EnableAutoUpdate
$VMConfig = Add-AzVMNetworkInterface -VM $VMConfig -Id (Get-AzNetworkInterface -ResourceGroupName $ResourceGroupName).Id
$VMConfig = Set-AzVMSourceImage -VM $VMConfig -PublisherName $ImagePublisher -Offer $ImageOffer -Skus $ImageSKU -Version latest
New-AzVM -ResourceGroupName $ResourceGroupName -Location $Location -VM $VMConfig

# Install Chocolatey Package Manager
$ScriptUrl = "https://chocolatey.org/install.ps1"
$ScriptFile = "C:\Windows\Temp\install.ps1"
(New-Object System.Net.WebClient).DownloadFile($ScriptUrl, $ScriptFile)
Set-ExecutionPolicy Bypass -Scope Process -Force; . $ScriptFile

# Install Software Packages
$Packages = "googlechrome", "firefox", "notepadplusplus", "7zip", "visualstudiocode", "putty"
foreach ($Package in $Packages) {
    choco install $Package -y
}

# Update Software Packages
choco update all -y

# Install Windows Updates
Install-WindowsUpdate -AcceptAll -AutoReboot
