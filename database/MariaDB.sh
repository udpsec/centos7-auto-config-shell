#!/bin/bash
# 文件名: MariaDB.sh
# 描述:  用于CentOS 7 系统使用rpm安装MariaDB
# 版本:  1.0
# 创建时间:  2016年11月28日
# 修订:  none
# 作者:  Selphia (sp), admin@factory.moe

# 变量

echo "#MariaDB 10.2 CentOS存储库列表 - 创建2017-09-29 12:22 UTC" >> /etc/yum.repos.d/MariaDB.repo
echo "# http://downloads.mariadb.org/mariadb/repositories/" >> /etc/yum.repos.d/MariaDB.repo
echo "[MariaDB]" >> /etc/yum.repos.d/MariaDB.repo
echo "name = MariaDB" >> /etc/yum.repos.d/MariaDB.repo
echo "baseurl = http://yum.mariadb.org/10.2/centos7-amd64 " >> /etc/yum.repos.d/MariaDB.repo
echo "gpgkey = https://yum.mariadb.org/RPM-GPG-KEY-MariaDB " >> /etc/yum.repos.d/MariaDB.repo
echo "gpgcheck = 1" >> /etc/yum.repos.d/MariaDB.repo

# 安装
yum -y upgrade
yum -y install MariaDB-server MariaDB-client

# 启动
systemctl start mariadb.service

# 设置开机启动
systemctl enable mariadb.service

# 设置 root 密码
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
systemctl restart mariadb.service

# 显示版本信息
systemctl status mariadb.service
mysql -V
