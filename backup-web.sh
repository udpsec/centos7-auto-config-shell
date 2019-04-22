#!/bin/bash
# 文件名:  backup-web.sh
# 描述:	备份网站所在文件夹，使用tar压缩并打包
#		备份数据库内容,需要设置要备份的数据库名、MySQL的用户名及密码
# 版本:  3.0
# 创建时间:  2016年12月25日
# 修订:  2017.01.08
# 作者:  Selphia (sp), admin@factory.moe

###环境变量
backup="~/Backup"					# 备份文件储存目录
time="$(date +%Y%m%d)"				# 设置当前日期
html="/usr/local/apache2/htdocs"	# html文件目录
config="/usr/local/apache2/conf"	# httpd.config文件目录
#owncloud="/var/owncloud"			# owncloud 目录
#mysql_name=""						# MySQL数据库名称
#mysql_user="root"					# Mysql用户名
#mysql_passwd=""					# Mysql密码
psql_name=""						# PostgreSQL数据库名称
psql_user="postgres"				# PostgreSQL用户名
psql_password=""					# PostgreSQL密码
### 建立备份目录
test -d $backup
if [ $? != "0" ]
then
	mkdir $backup
fi
cd $backup

### 备份 html 目录 (请注释掉不使用的目录)
tar -Jpcf "html_$time.tar.xz" "$html" "$config"

### 备份 owncloud (请注释掉不使用的目录)
#tar -Jpcf "owncloud_$time.tar.xz" "$owncloud"

### 备份 MariaDB 数据库 (请注释掉不使用的数据库)
#mysqldump -u"$mysql_user" -p"$mysql_passwd" $mysql_name > "$mysql_name"_"$time".MariaDB

### 备份 postgreSQL 数据库 (请注释掉不使用的数据库)
pg_dump "host=localhost port=5432 user=$psql_user dbname=$psql_name password=$psql_password" > "$psql_name"_"$time".pgsql
