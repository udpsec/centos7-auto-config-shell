#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# File Title: ngrok.py
# Author: Selphia
# Mail: LoliSound@gmail.com
# Time: 2017年07月16日 星期日 04时10分16秒
# Version: 

# Ngrok Install
import os
import shutil

print("""Please enter your system architecture:
1.) x64
2.) i386
3.) ARM (RaspBerry Pi)
""")
Arch=input()

if Arch == '':
    shutil.copy('linux_arm/ngrok','/usr/bin')
elif Arch == '1':
    shutil.copy('ngrok','/usr/bin')
elif Arch =='2':
    shutil.copy('linux_386/ngrok','/usr/bin')
elif Arch =='3':
    shutil.copy('linux_arm/ngrok','/usr/bin')
else:
    print('\033[31mError\033[0m')
    exit()

def rc_write(content):
    rc_local=[]
    rc=open('/etc/rc.local','r')
    for i in rc:
        rc_local.append(i)
    rc_local.insert(-1,content)
    rc.close()
    rc=open('/etc/rc.local','w')
    for i in rc_local:
        rc.write(i)
    rc.close()

Ngrok_Server='factory.moe'

ngrok_conf_content="server_addr: " + Ngrok_Server + """:4443
trust_host_root_certs: false

tunnels:
    http:
        subdomain: "ngrok"
#       auth: "user:passwd"
        proto:
            http: 80
    ssh:
        remote_port: 2222
        proto:
            tcp: 22
    aria2:
        remote_port: 6800
        proto:
            tcp: 6800
"""

ngrok_conf=open('/etc/ngrok.conf','w')
ngrok_conf.write(ngrok_conf_content)
ngrok_conf.close()

os.system('/usr/bin/setsid /usr/bin/ngrok -config /etc/ngrok.conf start http ssh aria2')
rc_write('\n/usr/bin/setsid /usr/bin/ngrok -config /etc/ngrok.conf start http ssh aria2\n\n')

# Success & exit
print('\033[32mOK!\033[0m')
exit()
