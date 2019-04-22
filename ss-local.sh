#!/bin/bash
# 文件名: ss-local.sh
# 描述:  用于CentOs7 系统，安装ShadowSocks的客户端。
# 版本:  1.0
# 创建时间:  2016年11月04日
# 修订:  None
# 作者:  Selphia (sp), admin@factory.moe

### 检测是否安装GCC
gcc --version

if [ $? != 0 ]
then
	echo 'Before you proceed, make sure that your system has a C compiler'
	exit 0
fi

# 显示python版本
echo "Python3 Version:"
python3 -V

if [ $? != '0' ]
then
	echo 'Before you proceed, make sure that your system has a python3'
	exit 0
fi

### 设置变量
LATEST='libsodium-*'

echo 'Server IP address'
read server_ip
echo 'Port number to be used'
read server_port
echo 'ShadowSocks password'
read password
echo 'In the end, you should choose to use the form of encryption that meets your security requirements.  a/c'
echo '(a) aes-256-cfb'
echo '(c) chacha20'

read method_
method='Null'
while [ $method == 'Null' ]
do
	if [ $method_ == 'a' ]
	then
		echo 'Encryption method : aes-256-cfb'
		method=aes-256-cfb
	elif [ $method_ == 'c' ]
	then
		echo 'Encryption method : chacha20'
		method=chacha20
	else
		echo -e "\033[1;31mEnter the error, please enter the correct encryption method\033[0m a/c"
		read method_
	fi
done

# 安装ShadowSocks
pip3 install shadowsocks

# 配置文件config.json
mkdir /etc/shadowsocks
echo "{
	\"server\":\"$server_ip\",
	\"server_port\":$server_port,
	\"local_address\": \"127.0.0.1\",
	\"local_port\":1080,
	\"password\":\"$password\",
	\"timeout\":300,
	\"method\":\"$method\",
	\"fast_open\": false
}" > /etc/shadowsocks/config.json


# 使用chacha20加密协议
wget https://download.libsodium.org/libsodium/releases/LATEST.tar.gz
tar -xvf LATEST.tar.gz
cd ./$LATEST
./configure
make all
make install
echo /usr/local/lib > /etc/ld.so.conf.d/usr_local_lib.conf
ldconfig

cd ..
rm -rf LATEST.tar.gz
rm -rf $LATEST

# 使用aes-256-cfb加密协议
yum install m2crypto -y

# 创建链接到/usr/bin
ln -sf /usr/local/python3/bin/ssserver /usr/bin
ln -sf /usr/local/python3/bin/sslocal /usr/bin

# 设置开机启动
echo "sslocal -c /etc/shadowsocks/config.json -d start" >> /etc/rc.d/rc.local
chmod a+x /etc/rc.d/rc.local

# 程序结束
sslocal -c /etc/shadowsocks/config.json -d start
echo 'If the installation was successful,ShadowSocks should now be running on your system.'
