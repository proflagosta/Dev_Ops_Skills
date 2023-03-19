# Create User Accounts with Initial Permissions
$User1 = "User1"
$User2 = "User2"
$Password = ConvertTo-SecureString "P@ssword123" -AsPlainText -Force

New-LocalUser -Name $User1 -Password $Password -FullName "User1" -Description "User1 Account"
New-LocalUser -Name $User2 -Password $Password -FullName "User2" -Description "User2 Account"

# Assign Initial Permissions
$Group1 = "Administrators"
$Group2 = "Users"
Add-LocalGroupMember -Group $Group1 -Member $User1
Add-LocalGroupMember -Group $Group2 -Member $User2

# Change User Permissions
Remove-LocalGroupMember -Group $Group1 -Member $User1
Add-LocalGroupMember -Group $Group2 -Member $User1
Remove-LocalGroupMember -Group $Group2 -Member $User2
