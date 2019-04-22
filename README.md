# **centos7-auto-config-shell**

Java环境自动安装脚本    jdk1.8、maven3.6.0、 Tomacat8.0  docker  docker-compose nodejs pm2

> 如果脚本执行完成，`java -version` `mvn -v` 显示没有命令，请断开服务器连接，重新连接下应该就好了。

## 使用方法

### 系统初始化配置

```
./BasicSet.sh
```

  说明：
    安装完 CentOS7 以后的一些简单设置，直接写个脚本执行，一个个输入命令太麻烦。
  功能：
    |-更新系统软件
    |-更改主机名
    |-更改主机时区为 '亚洲/上海'
    |-创建有sudo权限的普通用户，并设置密码
    |-更改ssh端口
    |-禁止ROOT用户使用ssh登录
    |-更改ssh登录时间限制
    |-关闭firewall防火墙
    |-关闭SELinux
    |-重启系统

### 安装JAVA开发环境

 ```
 ./java-env.sh(如果安装完了jdk 控制台没有显示安装信息,`重新连接下终端` 就好了)
 ```

### 安装DOcker环境

  ```
  ./docker-env.sh
  ```

##### 第二种从yum安装docker

```
./centos7_install_docker.sh
```

### 安装NodeJs环境

 ```
 ./node-env.sh
 ```
### 安装PIP 

```
 ./pip.sh
```

### 安装Python3

    ./Python3.sh

### 安装ShadowSocks

    ss-server.sh	(服务器)
    ss-local.sh		(客户端)
  使用 Python3 安装 ShadowSocks
  设置：
    |-服务器IP
    |-端口
    |-密码
    |-加密方式 (选择 aes-256-cfb 或 chacha20 ，推荐使用 chacha20)

### 安装Django-install.sh	(功能暂未完成)

	使用 Python3 安装 Django 框架。

### 安装无头chrome

headless-chrome

### 安装k8s

kubeadm

### 安装Go环境

go

### 安装pm2

  npm install pm2 -g

  通过pm2 start命令启动nodejs项目

  pm2 start app.js

  查看pm2管理的项目列表命令

  pm2 list

  查看某个项目的信息

  pm2 show 0 // 查看id为0的项目的信息

  停止pm2启动的项目命令

  pm2 stop 0 // 停止id为0的项目

  pm2 stop all // 停止所有项目

  重启某个项目

  pm2 restart 0 // 重启id为0的项目

  查看日志

  pm2 logs

安装MySQL 和POSTGRESQL数据库

database

### 安装PXE批量部署服务器系统

PXE

### 安装搜狗输入法

sogou-input-in-centos7

### 安装centos 7 Vagrant 开发环境

vagrant-centos7

http://qcloud.ikouqin.cn/download/jdk-8u212-linux-x86_64.tar.gz

### LAMP-install-yum.sh

	使用yum安装 httpd MariaDB 及 PHP
	安装方便，使用稳定。但是版本太低。
	不过能用就行啊……

### Apache2.sh	Nginx.sh	PHP7.sh

	使用编译的方法安装,版本更高，支持更多新的特性。
	但是可能会产生各种不可预料的问题。
	以及缺少一些模块、扩展功能。

### backup-web.sh

	备份网站所在文件夹，使用tar压缩并打包。
		html		默认地址：/etc/www/html
	备份数据库内容,需要设置要备份的数据库名、MySQL的用户名及密码
		backup		备份文件位置
		sql_name	需要备的数据库名
		sql_user	MySQL用户名，默认用户名：root
		sql_passwd	MySQL密码

### backup-everyday.sh(开发中)

	每天固定时间备份网站文件及数据库，备份的数据将被储存7天，7天后删除。
		time		每天备份程序的时间（时区以主机时区为准
### mysql-8.0.15.sh

安装MySQL8.0.13脚本

## 新上架机器后， 启用网卡

`vi /etc/sysconfig/network-scripts/ifcfg-ens33`

#修改 ONBOOT=no  为 ONBOOT=yes

#重启网络服务

`service network restart`

#查看ip

`ip addr`

#可选项目

```
yum install -y wget  git vim lrzsz screen net-tools telnet
```

### 替换yum源为ali源

#备份

`mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup`

#替换

`wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo`

#刷新数据

`yum makecache`

#更新到最新

`screen yum update -y`

------

> 可选操作：

### 更新时区

```
yum install -y ntp
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
echo 'Asia/Shanghai' >/etc/timezone
ntpdate time.windows.com

```