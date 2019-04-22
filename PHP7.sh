#!/bin/bash
# 文件名: PHP7.sh
# 描述:  用于 CentOS 7 系统使用编译安装 PHP7
# 版本:  1.0
# 创建时间:  2016年11月28日
# 修订:  none
# 作者:  Selphia (sp), admin@factory.moe

# 变量
php="php-7.1.0"

# 依赖
yum -y install libjpeg libjpeg-devel libpng libpng-devel freetype freetype-devel libxml2 libxml2-devel pcre-devel curl-devel libxslt-devel ImageMagick icu libicu libicu-devel

# 下载
wget "http://php.net/distributions/$php.tar.xz"
tar -xvf $php.tar.xz
cd $php

# 编译安装
./configure --prefix=/usr/local/php7 \
	--with-apxs2=/usr/local/apache2/bin/apxs \
	--with-curl \
 	--with-freetype-dir \
	--with-gd \
	--with-gettext \
	--with-iconv-dir \
	--with-kerberos \
	--with-libdir=lib64 \
	--with-libxml-dir \
	--with-openssl \
	--with-pcre-regex \
	--with-pear \
	--with-png-dir \
	--with-xmlrpc \
	--with-xsl \
	--with-zlib \
	--enable-fpm \
	--with-fpm-user=php-fpm \
	--with-fpm-group=php-fpm \
	--enable-bcmath \
	--enable-libxml \
	--enable-inline-optimization \
	--enable-gd-native-ttf \
	--enable-mbregex \
	--enable-mbstring \
	--enable-opcache \
	--enable-pcntl \
	--enable-shmop \
	--enable-soap \
	--enable-sockets \
	--enable-sysvsem \
	--enable-xml \
	--enable-zip \
	--with-mysqli \
	--with-pdo-mysql \
	--with-pdo-sqlite \
	--with-pgsql \
	--with-pdo-pgsql \
	--enable-intl \
	--with-icu-dir=/usr

# 安装
make
make install

cp php.ini-production /usr/local/php7/lib/php.ini
cp /usr/local/php7/etc/php-fpm.conf.default /usr/local/php7/etc/php-fpm.conf
cp /usr/local/php7/etc/php-fpm.d/www.conf.default /usr/local/php7/etc/php-fpm.d/www.conf

# 创建 php-fpm 用户
groupadd -r php-fpm
useradd php-fpm -g php-fpm -r -M -s /sbin/nologin

# 添加到系统服务
cp sapi/fpm/init.d.php-fpm /etc/rc.d/init.d/php-fpm
sed -i '1a # chkconfig: 35 71 71' /etc/rc.d/init.d/php-fpm
sed -i '2a # description: php-fpm' /etc/rc.d/init.d/php-fpm
chmod a+x /etc/init.d/php-fpm
chkconfig --add php-fpm
systemctl start php-fpm
systemctl enable php-fpm

# 快捷方式
ln -sf /usr/local/php7/bin/* /usr/bin/
build/shtool install -c ext/phar/phar.phar /usr/local/php7/bin
ln -sf -f phar.phar /usr/local/php7/bin/phar

# 添加 Apache2 的支持
sed -i 's/index.html/index.html index.php/g' /usr/local/apache2/conf/httpd.conf
echo '# PHP7 Setting' >> /usr/local/apache2/conf/httpd.conf
echo 'AddType application/x-httpd-php .php' >> /usr/local/apache2/conf/httpd.conf
echo 'AddType application/x-httpd-php-source .phps' >> /usr/local/apache2/conf/httpd.conf
systemctl restart httpd.service

# 安装apcu
pecl install apcu
echo "extension=apcu.so" >> /usr/local/php7/lib/php.ini
systemctl restart php-fpm.service
