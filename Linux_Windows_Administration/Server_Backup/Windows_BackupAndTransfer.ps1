# Variables
$SourceDir = "C:\path\to\parent\directory\target_folder"
$BackupName = "backup_folder.zip"
$LocalPath = (Get-Item $SourceDir).DirectoryName
$RemoteServer = "your_remote_server"
$RemoteUsername = "remote_user"
$RemotePassword = "remote_password"
$RemotePath = "/path/to/destination"

# Create a ZIP archive of the target folder
Set-Location -Path $LocalPath
Compress-Archive -Path (Split-Path -Leaf $SourceDir) -DestinationPath $BackupName

# Transfer the ZIP archive to the remote server using WinSCP
$WinSCPExePath = "C:\path\to\winscp.com"
$WinSCPScript = @"
    open sftp://$RemoteUsername:$RemotePassword@$RemoteServer
    put $BackupName $RemotePath
    exit
"@
$WinSCPScript | & $WinSCPExePath /script=-

# (Optional) Remove the local ZIP archive after successful transfer
Remove-Item -Path $BackupName

#Run script
#.\Windows_BackupAndTransfer.ps1

