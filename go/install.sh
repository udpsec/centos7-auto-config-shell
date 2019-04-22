wget https://dl.google.com/go/go1.11.5.linux-amd64.tar.gz
tar -C /usr/local -xzf go1.11.5.linux-amd64.tar.gz
echo '
export GOROOT=/usr/local/go 
export GOBIN=$GOROOT/bin 
export PATH=$PATH:$GOBIN ' >> ~/.bashrc  

source ~/.bashrc  


