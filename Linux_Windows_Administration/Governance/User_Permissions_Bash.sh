#!/bin/bash

# Create User Accounts with Initial Permissions
useradd -m -s /bin/bash user1
useradd -m -s /bin/bash user2
echo "P@ssword123" | passwd --stdin user1
echo "P@ssword123" | passwd --stdin user2

# Assign Initial Permissions
usermod -aG sudo user1
usermod -aG users user2

# Change User Permissions
usermod -G users user1
usermod -G sudo user2
