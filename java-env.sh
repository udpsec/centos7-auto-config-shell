#!/bin/bash

mkdir /opt/java

yum -y install wget

yum install glibc.i686 -y

echo '======================================='
echo '$                                     $'
echo '$      Jdk1.8 install ...             $'
echo '$                                     $'
echo '======================================='

#Oracle官网下载会有问题，必须要Accept License Agreement 加了前面这条命令就能下载成功
wget --no-check-certificate --no-cookies https://files-cdn.liferay.com/mirrors/download.oracle.com/otn-pub/java/jdk/8u121-b13/jdk-8u121-linux-x64.tar.gz

tar -zxvf jdk-8u121-linux-x64.tar.gz

rm -f -r jdk-8u121-linux-x64.tar.gz

mv  jdk1.8.0_121  /opt/java/jdk1.8

echo '======================================='
echo '$                                     $'
echo '$      Maven3.6 install ...           $'
echo '$                                     $'
echo '======================================='

wget http://mirrors.hust.edu.cn/apache/maven/maven-3/3.6.1/binaries/apache-maven-3.6.1-bin.tar.gz

tar -xzvf apache-maven-3.6.1-bin.tar.gz

rm -f -r  apache-maven-3.6.1-bin.tar.gz

mv  apache-maven-3.6.1 /opt/java/apache-maven-3.6.1

#yum 安装
# sudo wget http://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo -O /etc/yum.repos.d/epel-apache-maven.repo
# sudo sed -i s/\$releasever/6/g /etc/yum.repos.d/epel-apache-maven.repo
# sudo yum install -y apache-maven


echo 'export JAVA_HOME=/opt/java/jdk1.8' >> /etc/profile

echo 'export JRE_HOME=${JAVA_HOME}/jre' >> /etc/profile

echo 'export CLASSPATH=.:${JAVA_HOME}/lib:${JRE_HOME}/lib' >> /etc/profile

echo 'export PATH=${JAVA_HOME}/bin:$PATH' >> /etc/profile

echo 'export MAVEM_HOME=/opt/java/apache-maven-3.6.1' >> /etc/profile

echo 'export PATH=${MAVEM_HOME}/bin:$PATH' >> /etc/profile

if [ -e "/opt/java/apache-maven-3.6.1/conf/settings.xml" ]; then

  rm -f -r  /opt/java/apache-maven-3.6.1/conf/settings.xml
  
  mv settings.xml /opt/java/apache-maven-3.6.1/conf/
fi


source /etc/profile

# echo '***************************************'
# echo '*                                     *'
# echo '*      Tomcat8.5 install ...          *'
# echo '*                                     *'
# echo '***************************************'

wget https://mirrors.ustc.edu.cn/apache//tomcat/tomcat-8/v8.5.40/bin/apache-tomcat-8.5.40.tar.gz



tar -zxvf apache-tomcat-8.5.40.tar.gz

rm -f -r apache-tomcat-8.5.40.tar.gz

mv  apache-tomcat-8.5.40 /opt/java/apache-tomcat-8.5

cd /opt/opt/java/apache-tomcat-8.5/bin/

./startup.sh

java -version

mvn -v
