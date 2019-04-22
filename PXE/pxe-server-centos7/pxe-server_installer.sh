#!/bin/bash

set -e
set -x

# Check Privileges
root=$(id -u)
if [ "$root" -ne 0 ];then
    echo "You must run it as root."
    exit 1
fi

#INSTALL PACKAGES
yum -y install vim wget net-tools mc screen openssl rsync git
yum -y install syslinux tftp-server dhcp

# Global variables including DHCP configuration
WORKING_DIR=$(pwd $0)
DHCPDIR="/etc/dhcp"
DHCPSERVER="172.168.4.210"
DHCPSUBNETMASK="255.255.255.0"
DHCPSUBNET=$(ipcalc -n $DHCPSERVER $DHCPSUBNETMASK | cut -d "=" -f2)
DHCPBOARDCAST=$(ipcalc -b $DHCPSERVER $DHCPSUBNETMASK | cut -d "=" -f2)
DHCPRANGEFIRSTIP="172.168.4.212"
DHCPRANGELASTIP="172.168.4.219"


#TFTP configure
ln -s '/usr/lib/systemd/system/tftp.socket' '/etc/systemd/system/sockets.target.wants/tftp.socket'
cd /var/lib/tftpboot
yes |cp -fra ${WORKING_DIR}/isolinux/* /var/lib/tftpboot/
cp /usr/lib/systemd/system/tftp.service /etc/systemd/system
mv /etc/systemd/system/tftp.service /etc/systemd/system/tftp.service.org
yes |cp -fra ${WORKING_DIR}/conf/tftp.service /etc/systemd/system/tftp.service

systemctl start tftp.socket
systemctl enable tftp.socket

# configure dhcp server
cp $DHCPDIR/dhcpd.conf $DHCPDIR/dhcpd.conf_$(date +%F-%T)
cp dhcpd.conf-template dhcpd.conf-template-orig
sed -i s/"subnet 192.168.100.0 netmask 255.255.255.0"/"subnet $DHCPSUBNET netmask $DHCPSUBNETMASK"/g dhcpd.conf-template
sed -i s/"range 192.168.100.231 192.168.100.253;"/"range $DHCPRANGEFIRSTIP $DHCPRANGELASTIP;"/g dhcpd.conf-template
sed -i s/"option routers 192.168.100.1;"/"option routers $DHCPSERVER;"/g dhcpd.conf-template
sed -i s/"next-server 192.168.100.1;"/"next-server $DHCPSERVER;"/g dhcpd.conf-template
sed -i s/"option broadcast-address 192.168.100.254;"/"option broadcast-address $DHCPBROADCAST;"/g dhcpd.conf-template
mv dhcpd.conf-template dhcpd.conf-template-final
mv dhcpd.conf-template-orig dhcpd.conf-template
cp dhcpd.conf-template-final $DHCPDIR/dhcpd.conf
systemctl start dhcpd 
systemctl enable dhcpd
echo "-------------------------------------------
DHCP configured.
DHCP IP: $DHCPSERVER
DHCP MASK: $DHCPSUBNETMASK
DHCP BROADCAST: $DHCPBROADCAST
DHCP RANGE: $DHCPRANGEFIRSTIP - $DHCPRANGELASTIP
---------------------------------------------"
# ------------------ REPO LOCAL ------------------
#INSTALL PACKAGES 
yum -y install createrepo epel-release memtest86+
yum -y install nginx

#CREATE MIRROR LOCAL
VERSION="CentOS-7-x86_64-DVD-1511.iso";
CHECKOUT_DIR="/usr/src/isobuild";
mkdir -p  ${CHECKOUT_DIR}
mkdir -p /var/www/html/repos/centos/7/{os/x86_64,updates/x86_64}
mount -t iso9660 -o loop /root/${VERSION} ${CHECKOUT_DIR}
rsync -a -H  ${CHECKOUT_DIR}/ /var/www/html/repos/centos/7/os/x86_64/
umount ${CHECKOUT_DIR}

#CONFIGURATION NGINX
if [ -e /etc/nginx/nginx.conf ];then
    mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.org
fi
yes |cp -fra ${WORKING_DIR}/nginx/* /etc/nginx/


# TEMPLATE KS
mkdir -p /var/www/html/repos/ks
yes |cp -fra ${WORKING_DIR}/ks/* /var/www/html/repos/ks/

# configure DHCP server in kickstart
sed -i "s/\(--url=http:\/\/\)172.168.4.210/\1${DHCPSERVER}/g" /var/www/html/repos/ks/centos7-ks.cfg

systemctl start nginx
systemctl enable nginx
