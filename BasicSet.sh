#!/bin/bash
# 文件名:  BasicSet.sh (基本设置)
# 描述:  用于 Linode 上 CentOS 7 系统安装完成后的一些设置。
# 版本:  1.1
# 创建时间:  2016年11月03日
# 修订:  None
# 作者:  Selphia (sp), admin@factory.moe

### 检测用户是否为Root

if [ "$UID" != "0" ]
then
	echo "请使用 root 账户执行本程序."
	exit 0
fi

### 定义及获取变量
echo "输入关于设置系统的一些信息，不输入信息并按回车键跳过。"

echo "请输入主机名："
read hostname

echo "请输入用户名："
read username
if test -n "$username"
then
    echo "请输入密码："
    read -s passwd
    echo "确认您输入的密码："
    read -s repasswd
    while [ "$passwd" != "$repasswd" ]
    do
        echo -e "\033[1;31m确认密码不相同。\n再次输入密码和确认密码：\033[0m"
        read -s passwd
        echo "请确认您输入的密码："
        read -s repasswd
    done
fi
echo "请输入SSH端口号："
read port

### 更改主机名
if test -n "$hostname"
then
	hostnamectl set-hostname $hostname
fi

### 更改主机时区为 '亚洲/上海'
timedatectl set-timezone 'Asia/Shanghai'

### 创建普通用户，并设置密码
if test -n "$username"
then
	useradd $username
	echo $passwd | passwd --stdin  $username
fi

### 给用户添加sudo权限
if test -n "$username"
then
	sed -i "s/root	ALL=(ALL) 	ALL/root	ALL=(ALL) 	ALL\n$username	ALL=(ALL) 	ALL/g" /etc/sudoers
fi

### 更改SSH设置

# 更改端口
if test -n "$port"
then
	sed -i "s/#   Port 22/    Port $port/g" /etc/ssh/ssh_config
	sed -i "s/#Port 22/Port $port/g" /etc/ssh/sshd_config
fi

# 禁止ROOT用户登录
if test -n "$username"
then
	sed -i "s/#PermitRootLogin yes/PermitRootLogin no/g" /etc/ssh/sshd_config
	sed -i "s/PermitRootLogin yes/PermitRootLogin no/g" /etc/ssh/sshd_config
fi

# 更改登录时间限制
sed -i "s/#TCPKeepAlive yes/TCPKeepAlive yes/g" /etc/ssh/sshd_config
sed -i "s/#ClientAliveInterval 0/ClientAliveInterval 60/g" /etc/ssh/sshd_config
sed -i "s/#ClientAliveCountMax 3/ClientAliveCountMax 120/g" /etc/ssh/sshd_config

# 重启ssh服务
systemctl restart sshd.service

### 关闭firewall防火墙
systemctl stop firewalld.service #停止firewall
systemctl disable firewalld.service #禁止firewall开机启动

### 关闭SELinux
sed -i 's/SELINUX=enforcing/#SELINUX=enforcing/g' /etc/selinux/config
sed -i 's/SELINUXTYPE=targeted/#SELINUXTYPE=targeted/g' /etc/selinux/config
echo 'SELINUX=disabled' >> /etc/selinux/config
setenforce 0

# 重启网络服务
systemctl restart network
