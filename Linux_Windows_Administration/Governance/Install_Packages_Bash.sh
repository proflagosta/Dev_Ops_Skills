#!/bin/bash

# Install Required Packages
sudo apt-get update
sudo apt-get install -y curl gnupg2 ca-certificates lsb-release

# Install Visual Studio Code Repository Key
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
rm packages.microsoft.gpg

# Add Visual Studio Code Repository
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'

# Update Packages
sudo apt-get update

# Install Software Packages
Packages=("google-chrome-stable" "firefox" "notepadqq" "p7zip-full" "code" "putty")
for Package in "${Packages[@]}"
do
    sudo apt-get install -y $Package
done

# Update Software Packages
sudo apt-get upgrade -y

# Install Security Patches
sudo apt-get dist-upgrade -y
