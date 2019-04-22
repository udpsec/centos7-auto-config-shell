#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# File Title: Samba.py
# Author: Selphia
# Mail: LoliSound@gmail.com
# Time: 2017年07月29日 星期六 21时40分17秒
# Version: Beta 1.0

import os
import shutil
from pwd import getpwnam

# Samba
print("Please enter a Samba name: ")
Samba_Name=input()

print('Will be built under the home directory\nPlease enter a directory name: ')
Samba_Dir=input()


while os.path.exists(Samba_Dir):
    print('This directory already exists\nPlease re-enter the directory name: ')
    Samba_Dir=input()

os.system('apt update && apt upgrade -y  && apt autoremove -y')
os.system('apt install samba -y')

nobody=getpwnam('nobody')
os.makedirs(Samba_Dir)
os.chmod(Samba_Dir, 0o777)
os.chown(Samba_Dir, nobody.pw_uid, nobody.pw_gid)
smb_conf_file='/etc/samba/smb.conf'
smb_conf='\n\n[' + Samba_Name + ']\npath=' + Samba_Dir + '\nwriteable = yes\nbrowseable = yes\nguest ok = yes\n'

if os.path.isfile(smb_conf_file):
    shutil.copy(smb_conf_file,smb_conf_file + '.bak')

smb=open(smb_conf_file,'a')
smb.write(smb_conf)
smb.close()

# Success & exit
print('\033[32mInstall is complete\033[0m')
exit()
