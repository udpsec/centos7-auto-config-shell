#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# File Title: Aria2.py
# Author: Selphia
# Mail: LoliSound@gmail.com
# Time: 2017年07月29日 星期六 21时49分38秒
# Version:

import os
import shutil



print('\033[32mYou will use the /var/www/html directory !!!  y/n\033[0m')
confirm=input()
while True:
    if confirm == "y" or confirm == "Y":
        break
    elif confirm == "n" or confirm == "N":
        exit()
    else:
        print("Yse or No ?   y/n")
        confirm=input()

print('Please enter a directory name: ')
Aria2_Dir=input()
while os.path.exists(Aria2_Dir):
    print('This directory already exists\nPlease re-enter the directory name: ')
    Aria2_Dir=input()

os.system('apt update && apt upgrade -y  && apt autoremove -y')
os.system('apt install aria2 apache2 git -y')


# Aria2
webui_aria2='git://github.com/ziahamza/webui-aria2.git'
os.system('git clone ' + webui_aria2)
os.rename("/var/www/html","/var/www/html.bak")
shutil.copytree("webui-aria2","/var/www/html")
shutil.rmtree("webui-aria2")
aria2start='aria2c --enable-rpc --rpc-listen-all --dir=' + Aria2_Dir + ' -D'

os.system(aria2start)

def rc_write(content):
    rc_local=[]
    rc=open('/etc/rc.local','r')
    for i in rc:
        rc_local.append(i)
    rc_local.insert(-1,content)
    rc.close()
    rc=open('/etc/rc.local','w')
    for i in rc_local:
        rc.write(i)
    rc.close()

aria2_cfg_content="""# 文件的保存路径(可使用绝对路径或相对路径), 默认: 当前启动位置
dir=/home/RaspBerry
# NTFS建议使用falloc, EXT3/4建议trunc, MAC 下需要注释此项
#file-allocation=none
# 断点续传
continue=true

## 下载连接相关 ##

# 最大同时下载任务数, 运行时可修改, 默认:5
max-concurrent-downloads=10
# 同一服务器连接数, 添加时可指定, 默认:1
max-connection-per-server=15
# 最小文件分片大小, 添加时可指定, 取值范围1M -1024M, 默认:20M
# 假定size=10M, 文件为20MiB 则使用两个来源下载; 文件为15MiB 则使用一个来源下载
min-split-size=10M
# 单个任务最大线程数, 添加时可指定, 默认:5
split=50
# 整体下载速度限制, 运行时可修改, 默认:0
#max-overall-download-limit=0
# 单个任务下载速度限制, 默认:0
#max-download-limit=0
# 整体上传速度限制, 运行时可修改, 默认:0
#max-overall-upload-limit=0
# 单个任务上传速度限制, 默认:0
#max-upload-limit=0
# 禁用IPv6, 默认:false
disable-ipv6=true

## 进度保存相关 ##

# 从会话文件中读取下载任务
input-file=/etc/aria2/aria2.session
# 在Aria2退出时保存`错误/未完成`下载任务到会话文件
save-session=/etc/aria2/aria2.session
# 定时保存会话, 0为退出时才保存, 需1.16.1以上版本, 默认:0
save-session-interval=10

## RPC相关设置 ##

# 启用RPC, 默认:false
enable-rpc=true
# 允许所有来源, 默认:false
rpc-allow-origin-all=true
# 允许非外部访问, 默认:false
rpc-listen-all=true
# 事件轮询方式, 取值:[epoll, kqueue, port, poll, select], 不同系统默认值不同
#event-poll=select
# RPC监听端口, 端口被占用时可以修改, 默认:6800
rpc-listen-port=6800
# 设置的RPC授权令牌, v1.18.4新增功能, 取代 --rpc-user 和 --rpc-passwd 选项
#rpc-secret=<SECRET>
# 设置的RPC访问用户名, 此选项新版已废弃, 建议改用 --rpc-secret 选项
#rpc-user=<USER>
# 设置的RPC访问密码, 此选项新版已废弃, 建议改用 --rpc-secret 选项
#rpc-passwd=<PASSWD>

## BT/PT下载相关 ##

# 当下载的是一个种子(以.torrent结尾)时, 自动开始BT任务, 默认:true
follow-torrent=true
# BT监听端口, 当端口被屏蔽时使用, 默认:6881-6999
listen-port=51413
# 单个种子最大连接数, 默认:55
#bt-max-peers=55
# 打开DHT功能, PT需要禁用, 默认:true
enable-dht=true
# 打开IPv6 DHT功能, PT需要禁用
enable-dht6=true
# DHT网络监听端口, 默认:6881-6999
#dht-listen-port=6881-6999
# 本地节点查找, PT需要禁用, 默认:false
bt-enable-lpd=true
# 种子交换, PT需要禁用, 默认:true
enable-peer-exchange=true
# 每个种子限速, 对少种的PT很有用, 默认:50K
#bt-request-peer-speed-limit=50K
# 客户端伪装, PT需要
peer-id-prefix=-TR2770-
user-agent=Transmission/2.77
# 当种子的分享率达到这个数时, 自动停止做种, 0为一直做种, 默认:1.0
seed-ratio=0
# 强制保存会话, 即使任务已经完成, 默认:false
# 较新的版本开启后会在任务完成后依然保留.aria2文件
force-save=true
# BT校验相关, 默认:true
#bt-hash-check-seed=true
# 继续之前的BT任务时, 无需再次校验, 默认:false
bt-seed-unverified=true
# 保存磁力链接元数据为种子文件(.torrent文件), 默认:false
bt-save-metadata=true
"""
os.mkdir("/etc/aria2")
os.mknod("/etc/aria2/aria2.session")
aria2_cfg=open('/etc/aria2/aria2.cfg','w')
aria2_cfg.write(aria2_cfg_content)
aria2_cfg.close()

rc_write('\n/usr/bin/' + aria2start + '\n')

# Success & exit
print('\033[32mInstall is complete\033[0m')
exit()
