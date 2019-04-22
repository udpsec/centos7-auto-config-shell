#!/usr/bin/env bash

# Install needed packages
yum install -y dhcp tftp tftp-server syslinux wget vsftpd

# Configure eth1
cat << EOF > /etc/sysconfig/network-scripts/ifcfg-eth1
DEVICE="eth1"
BOOTPROTO="static"
ONBOOT="yes"
TYPE="Ethernet"
IPADDR=172.16.10.5
NETMASK=255.255.255.0
EOF

systemctl restart network

# Configure DHCPD
cat << EOF > /etc/dhcp/dhcpd.conf
# DHCP Server Configuration file.
#   see /usr/share/doc/dhcp*/dhcpd.conf.example
#   see dhcpd.conf(5) man page
#
# option definitions common to all supported networks...
ddns-update-style interim;
ignore client-updates;
authoritative;
allow booting;
allow bootp;
allow unknown-clients;
subnet 172.16.10.0 netmask 255.255.255.0 {
  range 172.16.10.50 172.16.10.253;
  option domain-name-servers 172.16.10.5;
  option domain-name "server1.example.com";
  option routers 172.16.10.5;
  option broadcast-address 172.16.10.255;
  default-lease-time 600;
  max-lease-time 7200;

  next-server 172.16.10.5;
  filename "pxelinux.0";
}
EOF
systemctl start dhcpd
systemctl enable dhcpd

# Enable TFTP and FTP
systemctl start tftp.socket
systemctl enable tftp.socket
systemctl start vsftpd
systemctl enable vsftpd

# Prepare the PXE Boot
if [ ! -e /home/vagrant/sync/CentOS-7-x86_64-Minimal-1511.iso ]
then
  wget --quiet http://mirror.uv.es/mirror/CentOS/7/isos/x86_64/CentOS-7-x86_64-Minimal-1511.iso -P /tmp
fi
mount /tmp/CentOS-7-x86_64-Minimal-1511.iso /mnt
rsync -a /mnt/ /var/ftp/pub
umount /mnt
mkdir -p /var/lib/tftpboot/pxelinux.cfg
mkdir -p /var/lib/tftpboot/netboot
cp /usr/share/syslinux/{pxelinux.0,menu.c32,memdisk,mboot.c32,chain.c32} /var/lib/tftpboot
cp /var/ftp/pub/images/pxeboot/{vmlinuz,initrd.img} /var/lib/tftpboot/netboot

cat << EOF > /var/lib/tftpboot/pxelinux.cfg/default
default menu.c32
prompt 0
timeout 30
MENU TITLE *** PXE Menu ***

LABEL centos7_x64
MENU LABEL CentOS 7 X64
KERNEL /netboot/vmlinuz
APPEND initrd=/netboot/initrd.img inst.repo=ftp://172.16.10.5/pub ks=ftp://172.16.10.5/pub/ks.cfg
EOF

# Configure KickStart
cat << EOF > /var/ftp/pub/ks.cfg
#platform=x86, AMD64, or Intel EM64T
#version=DEVEL
# Install OS instead of upgrade
install
# Keyboard layouts
keyboard 'us'
# Root password
rootpw --plaintext toor
# System timezone
timezone Europe/Madrid --isUtc
# Use network installation
url --url="ftp://172.16.10.5/pub"
# System language
lang en_US
# Firewall configuration
firewall --disabled
# System authorization information
auth  --useshadow  --passalgo=sha512
# Use text mode install
text
# SELinux configuration
selinux --enforcing
# Do not configure the X Window System
skipx

# Network information
network  --bootproto=dhcp --device=eth0
# Reboot after installation
reboot
# System bootloader configuration
bootloader --location=mbr
# Partition clearing information
clearpart --all --initlabel
# Disk partitioning information
part /boot --size 250
part pv.01 --size 4096 --grow
volgroup vg01 pv.01
logvol / --fstype="ext4" --vgname=vg01 --name=root --grow --percent=75
logvol swap --fstype="swap" --recommended --vgname=vg01 --name=swap

# Package installation
%packages
@core
%end

EOF
