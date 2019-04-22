#!/usr/bin/env bash

VM="pxe-client"

VBoxManage createhd --filename ${VM}.vdi --size 8192
VBoxManage createvm --name $VM --ostype "Linux26_64" --register
VBoxManage storagectl $VM --name "SATA Controller" --add sata --controller IntelAHCI
VBoxManage storageattach $VM --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium ${VM}.vdi
VBoxManage modifyvm $VM --ioapic on
VBoxManage modifyvm $VM --boot1 disk --boot2 net --boot3 none --boot4 none
VBoxManage modifyvm $VM --memory 1024 --vram 16
VBoxManage modifyvm $VM --nic1 intnet --intnet1 pxe
VBoxManage startvm $VM --type gui
