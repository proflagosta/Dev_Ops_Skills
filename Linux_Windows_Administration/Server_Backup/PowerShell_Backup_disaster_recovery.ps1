# Set the computer name to backup
$ComputerName = "SERVER01"

# Define backup variables
$BackupPath = "C:\Backups"
$BackupName = "ServerBackup_$(Get-Date -Format 'yyyyMMdd')"
$BackupFile = "$BackupPath\$BackupName.zip"

# Define test environment variables
$TestPath = "C:\TestEnvironment"
$TestName = "TestServer"

# Create Backup Directory if it doesn't exist
if (!(Test-Path -Path $BackupPath)) {
    New-Item -ItemType Directory -Path $BackupPath
}

# Backup Server Data
Compress-Archive -Path "C:\Data" -DestinationPath $BackupFile

# Create Test Environment Directory
New-Item -ItemType Directory -Path $TestPath

# Restore Server Data to Test Environment
Expand-Archive -Path $BackupFile -DestinationPath $TestPath

# Rename Test Server
Rename-Computer -NewName $TestName -Restart

# Test Disaster Recovery
# To test disaster recovery, ensure all data and applications function correctly on the test server
