# Set domain names for AD forests and server names
$Forest1Name = "forest1.com"
$Forest2Name = "forest2.com"
$Server1Name = "server1"
$Server2Name = "server2"

# Set DSRM passwords for AD forests
$Forest1DSRMPassword = "P@ssw0rd1"
$Forest2DSRMPassword = "P@ssw0rd2"

# Create Forest 1 on Server 1
Invoke-Command -ComputerName $Server1Name -ScriptBlock {
    Install-ADDSForest -DomainName $using:Forest1Name -DomainNetbiosName ($using:Forest1Name -split "\.")[0] -InstallDNS:$true -NoRebootOnCompletion:$true -Force:$true -Confirm:$false -SafeModeAdministratorPassword (ConvertTo-SecureString $using:Forest1DSRMPassword -AsPlainText -Force)
}

# Create Forest 2 on Server 2
Invoke-Command -ComputerName $Server2Name -ScriptBlock {
    Install-ADDSForest -DomainName $using:Forest2Name -DomainNetbiosName ($using:Forest2Name -split "\.")[0] -InstallDNS:$true -NoRebootOnCompletion:$true -Force:$true -Confirm:$false -SafeModeAdministratorPassword (ConvertTo-SecureString $using:Forest2DSRMPassword -AsPlainText -Force)
}

# Create cross-forest trust from Forest 1 to Forest 2
Invoke-Command -ComputerName $Server1Name -ScriptBlock {
    New-ADTrust -SourceName $using:Forest1Name -TargetName $using:Forest2Name -TrustDirection Bidirectional -TrustType Forest -Verbose
}

# Create cross-forest trust from Forest 2 to Forest 1
Invoke-Command -ComputerName $Server2Name -ScriptBlock {
    New-ADTrust -SourceName $using:Forest2Name -TargetName $using:Forest1Name -TrustDirection Bidirectional -TrustType Forest -Verbose
}

# Test cross-forest trust by creating a new user in Forest 1 with group membership from Forest 2
$User3Name = "User3"
$User3Password = "P@ssw0rd3!"
$User3Groups = Invoke-Command -ComputerName $Server2Name -ScriptBlock {
    Get-ADGroup -Server $using:Forest2Name -Filter {Name -like "Group*"}
}
Invoke-Command -ComputerName $Server1Name -ScriptBlock {
    New-ADUser -Name $using:User3Name -AccountPassword (ConvertTo-SecureString $using:User3Password -AsPlainText -Force) -Enabled $true -Path "OU=Users,DC=$using:Forest1Name" -SamAccountName $using:User3Name -Server $using:Server1Name -Credential (Get-Credential) -OtherAttributes @{primaryGroupID='513'} -PassThru | Add-ADPrincipalGroupMembership -Server $using:Server2Name -MemberOf $using:User3Groups
}
