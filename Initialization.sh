#!/usr/bin/env bash

# File Title: Initialization.sh
# Author: Selphia
# Mail: LoliSound@gmail.com
# Time: 2017年09月28日 星期四 13时38分09秒
# Version:

# 升级系统
yum -y update
# 安装软件
yum -y install vim
yum -y install zsh
yum -y install git
yum -y install wget
yum -y install tar bzip2
yum -y install gcc gcc-c++
yum -y install openssl openssl-devel
yum -y install apr apr-devel
yum -y install apr-util apr-util-devel
yum -y install pcre pcre-devel
yum -y install zlib zlib-devel
yum -y install autoconf automake
# oh-my-zsh
sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
# vim配置
git clone https://github.com/selphia/my-vim-config
cd my-vim-config
./install.sh
cd ..
rm -rf my-vim-config
