#!/bin/bash
# 文件名: Apache2.sh
# 描述:  用于 CentOS 7 系统编译安装 Apache2
# 版本:  2.4.27
# 创建时间:  2016.11.17
# 修订时间:  2017.1.4、2017.9.28
# 作者:  Selphia (sp), admin@factory.moe

# 变量
apache="httpd-2.4.27"

# 下载
wget "http://mirrors.hust.edu.cn/apache//httpd/$apache.tar.bz2"
tar -xvf $apache.tar.bz2
cd ./$apache

# 编译
./configure \
	--prefix=/usr/local/apache2 \
	--enable-so \
	--enable-cgi \
	--enable-ssl \
	--enable-rewrite \
	--enable-deflate \
	--enable-expires \
	--enable-headers \
	--with-zlib \
	--with-pcre \
	--enable-modules=all \
	--enable-mpms-shared=all

# 安装
make all
make install

# 创建链接
ln -sf /usr/local/apache2/bin/* /usr/bin

# 启动
#apachectl -k start

# 创建用户
groupadd -r apache
useradd apache -g apache -r -M -s /sbin/nologin
chown -R apache:apache /usr/local/apache2
sed -i 's/User daemon/User apache/g' /usr/local/apache2/conf/httpd.conf
sed -i 's/Group daemon/Group apache/g' /usr/local/apache2/conf/httpd.conf

# 添加到系统服务
#apachectl -k stop
cp /usr/local/apache2/bin/apachectl  /etc/rc.d/init.d/httpd
sed -i '1a # chkconfig: 35 70 70' /etc/rc.d/init.d/httpd
sed -i '2a # description: Apache' /etc/rc.d/init.d/httpd
chkconfig --add httpd

# 创建/var/www/html
# mkdir /var/www/
# ln -sf /usr/local/apache2/htdocs /var/www/html

# 启动服务
systemctl start httpd.service

# 开机启动
systemctl enable httpd.service

# 显示版本信息
systemctl status httpd.service
echo "\n"
httpd -v
