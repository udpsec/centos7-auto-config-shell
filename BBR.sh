#!/usr/bin/env bash
# File Title: BBR.sh
# Author: Selphia
# Mail: LoliSound@gmail.com
# Time: 2017年09月30日 星期六 18时04分16秒
# Version: 1.0
yum -y update
rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-3.el7.elrepo.noarch.rpm
yum --enablerepo=elrepo-kernel install kernel-ml -y
egrep ^menuentry /etc/grub2.cfg | cut -f 2 -d \'
grub2-set-default 0
reboot
