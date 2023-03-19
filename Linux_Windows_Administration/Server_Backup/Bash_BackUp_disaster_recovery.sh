#!/bin/bash

# Set the computer name to backup
ComputerName="SERVER01"

# Define backup variables
BackupPath="/mnt/backups"
BackupName="ServerBackup_$(date +%Y%m%d).tar.gz"
BackupFile="$BackupPath/$BackupName"

# Define test environment variables
TestPath="/mnt/test"
TestName="TestServer"

# Create Backup Directory if it doesn't exist
if [ ! -d "$BackupPath" ]; then
  sudo mkdir $BackupPath
  sudo chmod 777 $BackupPath
fi

# Backup Server Data
sudo tar -czvf $BackupFile /var/www /etc/apache2/sites-available

# Create Test Environment Directory
sudo mkdir $TestPath
sudo chmod 777 $TestPath

# Restore Server Data to Test Environment
sudo tar -xzvf $BackupFile -C $TestPath --strip-components=2

# Rename Test Server
sudo hostnamectl set-hostname $TestName

# Test Disaster Recovery
# To test disaster recovery, ensure all data and applications function correctly on the test server
