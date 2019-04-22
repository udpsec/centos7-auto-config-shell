#!/bin/bash
# Title: postgreSQL.sh
# Author: Selphia (sp), admin@factory.moe
# Time: 2017.01.04
# Version:	2017.09.28 9.6

# 安装
yum -y install https://download.postgresql.org/pub/repos/yum/9.6/redhat/rhel-7-x86_64/pgdg-centos96-9.6-3.noarch.rpm
yum -y install postgresql96 postgresql96-server postgresql96-devel

/usr/pgsql-9.6/bin/postgresql96-setup initdb
systemctl enable postgresql-9.6.service
systemctl start postgresql-9.6.service

# 显示 postgreSQL 版本
ln -sf `find / -name pg_config` /usr/bin
sed -i '80,84s/peer/md5/g' `find / -name pg_hba.conf`
sed -i '80,84s/ident/md5/g' `find / -name pg_hba.conf`
systemctl restart postgresql-9.6.service
systemctl status postgresql-9.6.service
psql -V
