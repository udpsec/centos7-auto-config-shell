1. For PXE Boot, DHCP Server is required.
2. DHCP Server has to run in an private network.
3. TFTP Server has to run in the network.
4. HTTP Server is required as coreos-install can use -B BASEURL
5. (Optional) DNS Server for easier Name Resolution

Here, I need 3+1 services; DHCP, TFTP, HTTP, DNS

- Public IP Network : 192.168.11.0/24
- Private IP Network : 172.30.0.0/16
- Domain Name : ace.local
- DeployServer Host Name: center
- DeployServer Public NIC (eth0): 192.168.1.121
- DeployServer Private NIC (eth1): 172.30.1.1

I prepared these files for Cent OS 7.

# Files

- dlfiles.sh

 A download script for stable  coreos_production_pxe files and coreos_production_image files.
 You need to run it once.

 coreos_production_pxe.vmlinuz,coreos_production_pxe.cpio.gz need be replaced to TFTP / directory.
 coreos_production_image.bin.bz2 need be replaced to DocumentRoot/BuildNumber/ of your WebServer directory.

  ex. /var/lib/tftpboot/coreos_production_pxe.vmlinuz
  ex. /var/lib/tftpboot/coreos_production_pxe_image.cpio.gz
  
  ex. /var/www/html/1353.8.0/coreos_production_image.bin.bz2

-  ace.local.zone

 A zone file for ISC BIND server(named). 
   ex. /var/named/ace.local.zone

-  named.conf

 A named server config

  ex. /etc/named.conf

-  default

 You will/would make DIRectory "pxelinux.cfg" in TFTP root.
 Copy "default" into the directory.

  ex. /var/lib/tftpboot/pxelinux.cfg/default
  
-  dhcpd.conf        
  
  ex. /etc/dhcp/dhcpd.conf
  
-  inst.sh

 A file to kick coreos-install with options
  ex. /var/www/html/inst.sh

-  pxe.ign

  Ignition config file for starting up after PXE boot.
  (ssh-rsa key is what of my id_rsa.pub)

# Usage

1. Install dhcpd, tftpd, httpd (+ named) on DeployServer(center).

2. Setup dhcpd, tftpd, httpd (+ named) on DeployServer(center).

 __IMPORTANT__: read comments in /etc/sysconfig/dhcpd

3. Run dlfiles.sh and move files into tftpboot/ and /var/www/html/buildnumber/

4. Move inst.sh/pxe.ign into /var/www/html

5. Machine boots with NIC (If you use Hyper-V VM, Legacy NIC is required.)
 
 Choose coreos-inst or noignition
 Container Linux boots up as live mode.

6. Get inst.sh to install CoreOS to Local Disk and kick it on the VM.

 core@localhost: ~ $ wget http://center/inst.sh

 core@localhost: ~ $ chmod +x inst.sh

 core@localhost: ~ $ ./inst.sh

