#!/bin/bash
#
# -------------------------------------------------------------------------------------
# PXE-Server automated installation script for CentOs 7 64bit
# -------------------------------------------------------------------------------------
# This script is only intended as a quickstart to test and get familiar with PXE-Server.
# The HOW-TO should be ALWAYS followed for a fully controlled, manual installation!
# -------------------------------------------------------------------------------------
#
#  Copyright notice:
#
#  (c) 2016 Federico Pereira <fpereira@cnsoluciones.com>
#
#  All rights reserved
#
#  This script is part of the PXE-Server project (https://github.com/lordbasex/PXE-Server-Centos-7)
#  The PXE-Server project is free software; you can redistribute it and/or 
#  modify it under the terms of the GNU Affero General Public License as 
#  published by the Free Software Foundation; either version 3 of 
#  the License, or (at your option) any later version.
#
#  You should have received a copy of the GNU Affero General Public License
#  along with this program.  If not, see <https://github.com/lordbasex/PXE-Server-Centos-7/blob/master/LICENSE>
#
#  This script is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU Affero General Public License for more details.
#
#  This copyright notice MUST APPEAR in all copies of the script!
#

# ------------------ TFTP LOCAL ------------------
#INSTALL PACKAGES
yum -y install vim wget net-tools mc screen openssl rsync git
yum -y install syslinux tftp-server

#DONWLOAD GIT
cd /usr/src/
git clone https://github.com/lordbasex/PXE-Server-Centos-7.git

#TFTP configure
ln -s '/usr/lib/systemd/system/tftp.socket' '/etc/systemd/system/sockets.target.wants/tftp.socket'
cd /var/lib/tftpboot
yes |cp -fra /usr/src/PXE-Server-Centos-7/isolinux/* /var/lib/tftpboot/
cp /usr/lib/systemd/system/tftp.service /etc/systemd/system
mv /etc/systemd/system/tftp.service /etc/systemd/system/tftp.service.org
yes |cp -fra /usr/src/PXE-Server-Centos-7/conf/tftp.service /etc/systemd/system/tftp.service

systemctl start tftp.socket
systemctl enable tftp.socket
#journalctl -f -n0

# ------------------ REPO LOCAL ------------------
#INSTALL PACKAGES 
yum -y install nginx
yum -y install createrepo epel-release memtest86+

#CREATE MIRROR LOCAL
VERSION="CentOS-7-x86_64-Minimal-1810.iso";
URL="http://mirror.facebook.net/centos/7/isos/x86_64"
CHECKOUT_DIR="/usr/src/isobuild";
mkdir -p  ${CHECKOUT_DIR}
mkdir -p /var/www/html/repos/centos/7/{os/x86_64,updates/x86_64}
cd /usr/src && wget ${URL}/${VERSION}
mount -t iso9660 -o loop /usr/src/${VERSION} ${CHECKOUT_DIR}
rsync -a -H  ${CHECKOUT_DIR}/ /var/www/html/repos/centos/7/os/x86_64/
umount ${CHECKOUT_DIR}

#CONFIGURATION NGINX
mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.org
yes |cp -fra /usr/src/PXE-Server-Centos-7/nginx/* /etc/nginx/

# TEMPLATE KS
mkdir -p /var/www/html/repos/ks
yes |cp -fra /usr/src/PXE-Server-Centos-7/ks/* /var/www/html/repos/ks/

systemctl start nginx
systemctl enable nginx
