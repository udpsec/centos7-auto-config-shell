#!/bin/bash
# 文件名: Nginx.sh
# 描述:  用于 CentOS 7 系统使用编译安装 Nginx
# 版本:  1.0
# 创建时间:  2016年11月30日
# 修订:  none
# 作者:  Selphia (sp), admin@factory.moe

# 变量
nginx="nginx-1.13.5"
yum -y install pcre pcre-devel  zlib zlib-devel openssl openssl-devel
# 下载
wget "http://nginx.org/download/$nginx.tar.gz"
tar -xvf $nginx.tar.gz
cd $nginx

# 编译并安装
./configure \
	--prefix=/usr/local/nginx \
	--sbin-path=/usr/sbin/nginx \
	--conf-path=/etc/nginx.conf \
	--error-log-path=/var/log/nginx/error.log \
	--http-log-path=/var/log/nginx/access.log \
	--pid-path=/var/run/nginx.pid \
	--lock-path=/var/run/nginx.lock \
	--http-client-body-temp-path=/var/cache/nginx/client_temp \
	--http-proxy-temp-path=/var/cache/nginx/proxy_temp \
	--http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
	--http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
	--http-scgi-temp-path=/var/cache/nginx/scgi_temp \
	--user=nginx \
	--group=nginx \
	--with-http_ssl_module \
	--with-http_realip_module \
	--with-http_addition_module \
	--with-http_sub_module \
	--with-http_dav_module \
	--with-http_flv_module \
	--with-http_mp4_module \
	--with-http_gunzip_module \
	--with-http_gzip_static_module \
	--with-http_random_index_module \
	--with-http_secure_link_module \
	--with-http_stub_status_module \
	--with-http_auth_request_module \
	--with-threads \
	--with-stream \
	--with-stream_ssl_module \
	--with-http_slice_module \
	--with-mail \
	--with-mail_ssl_module \
	--with-file-aio \
	--with-http_v2_module \
	--with-ipv6
make
make install

# 设置开机启动
echo "/usr/sbin/nginx -c /etc/nginx/nginx.conf" >> /etc/rc.d/rc.local
chmod a+x /etc/rc.d/rc.local

# 创建用户
groupadd -r nginx
useradd nginx -g nginx -r -M -s /sbin/nologin
chown -R nginx:nginx /etc/nginx

# 启动 nginx
mkdir -p /var/cache/nginx/client_temp
/usr/sbin/nginx -c /etc/nginx/nginx.conf

# 显示版本
nginx -v
