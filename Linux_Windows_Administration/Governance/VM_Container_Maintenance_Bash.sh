#!/bin/bash

# Configure virtual machine network
sudo virsh net-define vm_network.xml
sudo virsh net-start vm_network
sudo virsh net-autostart vm_network

# Create virtual machine
sudo virt-install \
--name my_vm \
--memory 2048 \
--vcpus 2 \
--disk path=/var/lib/libvirt/images/my_vm.qcow2,size=20 \
--os-type linux \
--os-variant centos8 \
--location 'http://mirror.centos.org/centos/8/BaseOS/x86_64/os/' \
--network network=vm_network \
--graphics none \
--console pty,target_type=serial \
--extra-args 'console=ttyS0,115200n8 serial'

# Start virtual machine
sudo virsh start my_vm

# Create container
sudo lxc launch images:centos/7/amd64 my_container

# Start container
sudo lxc start my_container

# Stop container
sudo lxc stop my_container

# Delete container
sudo lxc delete my_container

# Stop virtual machine
sudo virsh shutdown my_vm

# Delete virtual machine
sudo virsh undefine my_vm

# Remove virtual machine disk image
sudo rm /var/lib/libvirt/images/my_vm.qcow2
