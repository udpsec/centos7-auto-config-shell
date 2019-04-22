## generate a script file that downloads OpenBSD 6.1 amd64 release installer for pxe installation
# Usage: sh get61.sh 

BASEURL="http://ftp.jaist.ac.jp/pub/OpenBSD/6.1/amd64"
curl ${BASEURL}/index.txt 2> /dev/null | awk -v p=${BASEURL} ' $1!~/^t/ && $NF~/tgz$|pxeboot|^bsd|index.txt|SHA/ {printf("curl -O %s/%s\n",p,$NF)}'
