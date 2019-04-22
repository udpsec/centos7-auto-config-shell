#!/usr/bin/env bash
# File Title: Django.sh
# Author: Selphia
# Mail: LoliSound@gmail.com
# Time: 2017年09月30日 星期六 21时04分22秒
# Version: 1.0

pip3 install Django
pip3 install mod_wsgi
ln -sf /usr/local/python3/bin/* /usr/bin/
mod_wsgi-express install-module
echo "# My Settings" >> /usr/local/apache2/conf/httpd.conf
echo "SetEnv PYTHONIOENCODING utf8" >> /usr/local/apache2/conf/httpd.conf
echo "\n" >> /usr/local/apache2/conf/httpd.conf
mod_wsgi-express install-module | tee -a  /usr/local/apache2/conf/httpd.conf
systemctl restart httpd.service
