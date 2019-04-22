#!/bin/bash
# 文件名:  Python3.sh
# 描述:  用于 CentOS 7 系统编译安装 Python3
# 版本:  3.6.2
# 创建时间:  2016年11月02日
# 修订:  2017年9月28日
# 作者:  Selphia (sp), admin@factory.moe

# 变量
python="3.6.2"

### 检测是否安装GCC
gcc --version

if [ $? != 0 ]
then
	echo 'Before you proceed, make sure that your system has a C compiler'
	exit 0
fi

# 解决依赖
yum install gcc zlib zlib-devel openssl openssl-devel sqlite-devel bzip2-devel expat-devel gdbm-devel readline-devel -y

# 下载、解压、编译、安装Python
wget "https://www.python.org/ftp/python/$python/Python-$python.tar.xz"
tar -xvf "Python-$python.tar.xz"
cd "./Python-$python"
./configure --prefix=/usr/local/python3 --enable-shared
make all
make install

# 设置链接
ln -sf /usr/local/python3/bin/* /usr/bin
echo "/usr/local/python3/lib" >> /etc/ld.so.conf
ldconfig

# 更新pip3、安装wheel
pip3 install --upgrade pip
pip3 install setuptools
pip3 install wheel
# 结束
python3 -V
