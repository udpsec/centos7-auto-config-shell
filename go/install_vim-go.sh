mkdir rpms
cd rpms

wget https://download-ib01.fedoraproject.org/pub/epel/7/x86_64/Packages/g/golang-bin-1.11.5-1.el7.x86_64.rpm
wget https://download-ib01.fedoraproject.org/pub/epel/7/x86_64/Packages/g/golang-1.11.5-1.el7.x86_64.rpm
wget https://download-ib01.fedoraproject.org/pub/epel/7/x86_64/Packages/g/golang-src-1.11.5-1.el7.noarch.rpm
wget https://download-ib01.fedoraproject.org/pub/epel/7/x86_64/Packages/v/vim-go-1.8-3.el7.x86_64.rpm


rpm -ivh golang-src-1.11.5-1.el7.noarch.rpm golang-1.11.5-1.el7.x86_64.rpm golang-bin-1.11.5-1.el7.x86_64.rpm 
rpm -ivh vim-go-1.8-3.el7.x86_64.rpm 
