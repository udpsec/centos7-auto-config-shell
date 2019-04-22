#!/bin/bash
echo "***********************************************"
echo "*           欢迎使用Super-Mysql版脚本         *"
echo "***********************************************"
cd /usr/local
echo "正在检测是否安装wget..."
if [ `yum list installed | grep wget |wc -l` -ne 0 ];then
echo "wget已安装"
else
yum -y install wget
fi
if [ ! -f "/usr/local/mysql-8.0.15-linux-glibc2.12-x86_64.tar.xz" ];then
echo "正在下载mysql..."
else
rm -rf /usr/local/mysql-8.0.15-linux-glibc2.12-x86_64.tar.xz
echo "正在下载mysql..."
fi
wget https://www.mirrorservice.org/sites/ftp.mysql.com/Downloads/MySQL-8.0/mysql-8.0.15-linux-glibc2.12-x86_64.tar
if [ -d "/usr/local/mysql-8.0.15-linux-glibc2.12-x86_64" ];then
echo "/usr/local/mysql-8.0.15-linux-glibc2.12-x86_64文件夹存在"
rm -rf mysql-8.0.15-linux-glibc2.12-x86_64
echo "文件解压中..."
else
echo "文件解压中..."
fi
tar xvJf mysql-8.0.15-linux-glibc2.12-x86_64.tar.xz
rm -rf /usr/local/mysql-8.0.15-linux-glibc2.12-x86_64.tar.xz
if [ -d "/usr/local/mysql" ];then
echo "/usr/local/mysql文件夹已存在"
echo "删除已安装的mysql"
rm -rf mysql
mv mysql-8.0.15-linux-glibc2.12-x86_64 mysql
else
mv mysql-8.0.15-linux-glibc2.12-x86_64 mysql
fi
cd mysql
echo "正在添加默认配置文件..."
if [ ! -f "/etc/my.cnf" ];then
echo -e "[client]\nport=3306\nsocket=/tmp/mysql/mysql.sock\n\n[mysqld]\nport=3306\nuser=mysql\nsocket=/tmp/mysql/mysql.sock\nbasedir=/usr/local/mysql\ndatadir=/usr/local/mysql/data\nlog-error=error.log\n" >> /etc/my.cnf
else
rm -rf /etc/my.cnf
echo -e "[client]\nport=3306\nsocket=/tmp/mysql/mysql.sock\n\n[mysqld]\nport=3306\nuser=mysql\nsocket=/tmp/mysql/mysql.sock\nbasedir=/usr/local/mysql\ndatadir=/usr/local/mysql/data\nlog-error=error.log\n" >> /etc/my.cnf
fi
echo "正在检测是否安装libnuma.so.1..."
if [ `yum list installed | grep libnuma.so.1 |wc -l` -ne 0 ];then
echo "正在卸载libnuma.so.1"
yum remove libnuma.so.1
else
echo "未安装libnuma.so.1"
fi
echo "正在检测是否安装numactl.x86_64..."
if [ `yum list installed | grep numactl.x86_64 |wc -l` -ne 0 ];then
echo "numactl.x86_64已安装"
else
yum -y install numactl.x86_64
fi
echo "正在检测是否安装libaio-devel..."
if [ `yum list installed | grep libaio-devel |wc -l` -ne 0 ];then
echo "libaio-devel已安装"
else
yum -y install libaio-devel
fi
groupadd mysql
useradd -g mysql mysql
/usr/local/mysql/bin/mysqld --initialize --user=mysql --basedir=/usr/local/mysql/ --datadir=/usr/local/mysql/data/
if [ -d "/tmp/mysql" ];then
echo "/tmp/mysql文件夹已存在"
else
mkdir /tmp/mysql
fi
chown -R mysql:mysql /tmp/mysql
echo "正在检测是否安装net-tools..."
if [ `yum list installed | grep net-tools |wc -l` -ne 0 ];then
echo "net-tools已安装"
else
yum -y install net-tools
fi
if netstat -an | grep ':3306';then
echo "3306端口已被占用"
echo "端口被占用，即将退出脚本，请检查端口号"
exit
else
echo "3306端口未被占用"
fi
echo "正在启动mysql..."
./support-files/mysql.server start
echo "正在检测全局变量配置..."
profileStr=`cat /etc/profile`
matchStr="/usr/local/mysql"
result=$(echo $profileStr | grep "${matchStr}")
if [[ "$result" != "" ]]
then
    echo "全局变量/etc/profile中已存在mysql配置"
else
    echo "正在全局变量/etc/profile中写入mysql配置"
    echo -e "\n#set mysql environment\nexport MYSQL_HOME=/usr/local/mysql\nexport PATH=\$PATH:\$MYSQL_HOME/bin" >> /etc/profile
    source /etc/profile
fi
pwdLog=`sed -n '2,2p' /usr/local/mysql/data/error.log`
echo $pwdLog
pwdLog=${pwdLog/// }
arr=($pwdLog)
pwd=${arr[12]}
echo "默认密码是$pwd"
echo "正在修改初始密码..."
mysql -uroot -p$pwd --connect-expired-password -e "alter user'root'@'localhost' IDENTIFIED BY '123456';"
echo "请手动输入命令 source /etc/profile 刷新配置文件 即可使用mysql命令"
echo "mysql安装完成, 默认账号为root, 密码为123456"
