# PXE Server
Provision a CentOS 7 PXE Server using Vagrant and run a VirtualBox client
that automatically will boot and configure itself.

## Requirements
- [VirtualBox + Extension Pack](https://www.virtualbox.org/)
- [Vagrant](https://www.vagrantup.com/)

## Usage
1. Clone this repository
2. Execute ```vagrant up``` to start the PXE Server
3. Execute ```bash pxe-client.sh```to start the client
