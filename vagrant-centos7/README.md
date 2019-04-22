# centos7
>centos 7 Vagrant 开发环境（支持php版本切换，包含编译安装nginx，apache，mysql，php，redis，memcache，opache, 额外的ftp登录，phpmyadmin） 2017/08/18

特别感谢 [OneinStack](https://oneinstack.com) [GitHub](https://github.com/lj2007331/oneinstack)

## 预览图
![change_php_version](https://raw.githubusercontent.com/wiki/Hzhihua/vagrant-centos7/change-php-version.png)

## 依赖
- [Vagrant](https://www.vagrantup.com/downloads.html)
- [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
- [Git](https://git-scm.com/downloads)（Windows）

## 安装
> 在命令行执行(推荐)  
```coffeescript
vagrant init Hzhihua/centos7
vagrant up
```

> 配置Vagrantfile  
```coffeescript
Vagrant.configure("2") do |config|
  config.vm.box = "Hzhihua/centos7"
end
```

## 特色与说明
- centos 7 64位
- 大小, 1.7G
- [aliyun源](https://mirrors.aliyun.com/repo)
- 支持PHP版本切换（5.5 / 5.6 / 7.0 / 7.1）
- 全部软件通过编译安装
- 安装nginx（port: 80, version: 1.12.1, user: vagrant, group: vagrant）
- 安装apache（port: 88, version: 2.4.27, user:vagrant, group: vagrant）
- **为了统一nginx和apache的php接口，apache通过mod_proxy_fcgi连接PHP**
- PHP全部启用FastCGI进程管理器（FPM, user: vagrant, group: vagrant）
- MySQL（version: 5.6.37, username: root, password: 123123）
- 安装memcache
- 安装redis
- 安装Zend Opcache（默认关闭）
- phpMyAdmin
- FTP(未初始化)
- 网站根目录：/data/wwwroot/default/
- 软件安装路径：/usr/local/
- mysql 数据文件：/data/mysql/data
- 日记文件:
    - apache：/data/wwwlogs/apache
    - nginx: /data/wwwlogs/nginx
    - php：/data/wwwlogs/php
    - mysql：/data/mysql
