### How to deploy OpenBSD manually via PXE

 * **TFTP_ROOT**=/var/lib/tftpboot/

- get these files.
```# 
$ wget -O https://github.com/nakamkaz/pxe-cfgs/blob/master/genobsd61.sh
$ sh genobsd61.sh > getfiles.sh
$ sh getfiles.sh
```
```
SHA256
SHA256.sig
base61.tgz
bsd
bsd.mp
bsd.rd
comp61.tgz
game61.tgz
index.txt
man61.tgz
pxeboot
xbase61.tgz
xfont61.tgz
xserv61.tgz
xshare61.tgz
```
**COPY** _bsd.rd_ to $TFTP_ROOT. 

**COPY** _pxeboot_ to $TFTP_ROOT.

move other files to your web server directory.  

/var/www/html/pub/OpenBSD/6.1/amd64/
 
http://172.30.1.1/pub/OpenBSD/6.1/amd64/

("/pub/OpenBSD/RELEASE/ARCH/" is default path or you can specify any path)

- $TFTP_ROOT/pxelinux.cfg/default 
```
label obsd61
        menu label OpenBSD 6.1 amd64 release
        kernel pxechain.com
append ::pxeboot
```

- Create $TFTP_ROOT/etc/boot.conf
```
boot tftp:bsd.rd
```

- $TFTP_ROOT/bsd.rd, $TFTP_ROOT/pxeboot

ls -l /var/lib/tftpboot/bsd.rd

ls -l /var/lib/tftpboot/pxeboot


## Auto installation (unattended installation)

https://ftp.openbsd.org/pub/OpenBSD/snapshots/amd64/INSTALL.amd64

https://man.openbsd.org/autoinstall

``` Example install.conf, YO:UR:MA:CA:DR:ES-install.conf
System hostname = obsd8888
Password for root = Nakamura123
Setup a user = naka1
Password for user = Nakamura456
What timezone are you in = Japan
Location of sets = http
HTTP Server = 172.30.1.1
Use http instead = yes
```
Password value shouldn't be used plain text.

encrypt(1) should be used for creating Password hash ( $2b$... ).

.

