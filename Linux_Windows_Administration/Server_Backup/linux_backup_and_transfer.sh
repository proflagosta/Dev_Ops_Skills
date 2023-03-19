#!/bin/bash

# Variables
SOURCE_DIR="/path/to/parent/directory/target_directory"
BACKUP_NAME="backup_directory.tar.gz"
REMOTE_USER="ec2-user"
REMOTE_SERVER="your_public_ipv4_or_dns"
REMOTE_PATH="/path/to/destination"

# Create the tarball (compressed archive) of the target directory
cd "$(dirname "$SOURCE_DIR")"
tar -czvf "$BACKUP_NAME" "$(basename "$SOURCE_DIR")"

# Transfer the tarball to the remote server using scp
scp "$BACKUP_NAME" "$REMOTE_USER@$REMOTE_SERVER:$REMOTE_PATH"

# (Optional) Remove the local tarball after successful transfer
rm "$BACKUP_NAME"

# Make the file executable in bash 
#chmod +x linux_backup_and_transfer.sh

#run the script in bash
#./backup_and_transfer.sh

