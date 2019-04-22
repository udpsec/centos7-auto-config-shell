#!/bin/bash
# 文件名:  lamp-install-yum.sh
# 描述:  用于 CentOS 7 系统安装 Apache2 MariaDB PHP 。
# 版本:  1.0
# 创建时间:  2016年11月23日
# 修订:  None
# 作者:  Selphia (sp), admin@factory.moe

### 检测用户是否为Root
if [ $UID != "0" ]
then
	echo "请使用root帐户来执行此程序"
	exit 0
fi

# 安装 httpd
yum install httpd httpd-devel -y

# 启动 httpd
systemctl start httpd.service

# 设置开机启动 httpd
systemctl enable httpd.service

# 安装 MariaDB
yum install mariadb mariadb-devel  mariadb-server -y

# 启动 MariaDB
systemctl start mariadb.service

# 设置开机启动 MariaDB
systemctl enable mariadb.service

# 安装 PHP
yum install php php-devel -y

# 安装 PHP 组件
yum install php-mysql php-gd libjpeg* php-ldap php-odbc php-pear php-xml php-xmlrpc php-mbstring php-bcmath php-mhash -y

# 设置MariaDB密码
echo "接下来将执行MySQL安全配置向导"
echo "- 输入当前的root密码 (按Enter跳过)"
echo "- 设置root密码"
echo "- 删除匿名帐号"
echo "- 禁止root用户远程登录"
echo "- 删除测试数据库并禁止访问"
echo "- 重新加载权限表"
read -s -n1 -p "按任意键继续 ... "
mysql_secure_installation

# 重启 httpd MariaDB
systemctl restart httpd.service
systemctl restart mariadb.service

# 显示版本
echo -e "\nhttpd version :"
httpd -v
echo -e "\nMariaDB version :"
mysql -V
echo -e "\nPHP version :"
php -v
echo -e "\n\n安装结束"
