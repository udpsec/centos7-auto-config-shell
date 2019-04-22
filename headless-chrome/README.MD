
# 安装无头chrome


**因为众所周知的原因， 在国内集群上安装无头chrome （headless-chrome）的方式比较复杂， 并且不同安装方式的centos7 需要的步骤不太一样，所以不做一键脚本了**


首先执行
```
yum install yum-utils

rpm -i google-chrome-stable-73.0.3683.103-1.x86_64.rpm 
```
在一台服务器上得到结果
```
[root@localhost headless-chrome]# rpm -i google-chrome-stable-73.0.3683.103-1.x86_64.rpm 
warning: google-chrome-stable-73.0.3683.103-1.x86_64.rpm: Header V4 DSA/SHA1 Signature, key ID 7fac5991: NOKEY
error: Failed dependencies:
        libappindicator3.so.1()(64bit) is needed by google-chrome-stable-73.0.3683.103-1.x86_64
        liberation-fonts is needed by google-chrome-stable-73.0.3683.103-1.x86_64
        libnss3.so(NSS_3.22)(64bit) is needed by google-chrome-stable-73.0.3683.103-1.x86_64
        libssl3.so(NSS_3.28)(64bit) is needed by google-chrome-stable-73.0.3683.103-1.x86_64
```

在另一台服务器上得到结果

```
[root@150-95-178-87 headless-chrome]# rpm -i google-chrome-stable-73.0.3683.103-1.x86_64.rpm 
warning: google-chrome-stable-73.0.3683.103-1.x86_64.rpm: Header V4 DSA/SHA1 Signature, key ID 7fac5991: NOKEY
error: Failed dependencies:
        /usr/bin/lsb_release is needed by google-chrome-stable-73.0.3683.103-1.x86_64
        libXcomposite.so.1()(64bit) is needed by google-chrome-stable-73.0.3683.103-1.x86_64
        libXcursor.so.1()(64bit) is needed by google-chrome-stable-73.0.3683.103-1.x86_64
        libXdamage.so.1()(64bit) is needed by google-chrome-stable-73.0.3683.103-1.x86_64
        libXfixes.so.3()(64bit) is needed by google-chrome-stable-73.0.3683.103-1.x86_64
        libXi.so.6()(64bit) is needed by google-chrome-stable-73.0.3683.103-1.x86_64
        libXrandr.so.2()(64bit) is needed by google-chrome-stable-73.0.3683.103-1.x86_64
        libXrender.so.1()(64bit) is needed by google-chrome-stable-73.0.3683.103-1.x86_64
        libXss.so.1()(64bit) is needed by google-chrome-stable-73.0.3683.103-1.x86_64
        libXtst.so.6()(64bit) is needed by google-chrome-stable-73.0.3683.103-1.x86_64
        libappindicator3.so.1()(64bit) is needed by google-chrome-stable-73.0.3683.103-1.x86_64
        libatk-1.0.so.0()(64bit) is needed by google-chrome-stable-73.0.3683.103-1.x86_64
        libatk-bridge-2.0.so.0()(64bit) is needed by google-chrome-stable-73.0.3683.103-1.x86_64
        libatspi.so.0()(64bit) is needed by google-chrome-stable-73.0.3683.103-1.x86_64
        libcairo.so.2()(64bit) is needed by google-chrome-stable-73.0.3683.103-1.x86_64
        libcups.so.2()(64bit) is needed by google-chrome-stable-73.0.3683.103-1.x86_64
        liberation-fonts is needed by google-chrome-stable-73.0.3683.103-1.x86_64
        libgdk-3.so.0()(64bit) is needed by google-chrome-stable-73.0.3683.103-1.x86_64
        libgtk-3.so.0()(64bit) is needed by google-chrome-stable-73.0.3683.103-1.x86_64
        libpango-1.0.so.0()(64bit) is needed by google-chrome-stable-73.0.3683.103-1.x86_64
        libpangocairo-1.0.so.0()(64bit) is needed by google-chrome-stable-73.0.3683.103-1.x86_64
```


这时候可以尝试

```
yum localinstall google-chrome-stable-73.0.3683.103-1.x86_64.rpm
```

如果人品足够强大， 可以安装成功， 否则就必须根据上面的结果，寻找自己需要的rpm包


安装完毕之后可以用
```
google-chrome-stable --headless --disable-gpu --screenshot --no-sandbox --window-size=800,600 https://www.baidu.com
```
测试截图效果

--------------------

### 安装中文字体

绝大多数服务器都不会安装中文字体， 所以执行chrome时应该有类似下面的报错
```
Fontconfig warning: "/etc/fonts/fonts.conf", line 86: unknown element "blank"
```

#### 检查本地语言设置
```
echo $LANG
locale
locale -a |grep "zh_CN"
```


#### 安装必要字体软件
```
yum groupinstall "fonts"
yum install fontconfig
yum install ttmkfdir
```

此时再执行截屏
```
google-chrome-stable --headless --disable-gpu --screenshot --no-sandbox --window-size=800,600 https://www.baidu.com
```
应该有中文， 并且中文字体比较奇怪， 这是因为只安装了必要的开源字体， 如果需要显示效果和windows一样，
##### 需要自行安装windows的字体。

```
mkdir /usr/share/fonts/chinese/
chmod 755 /usr/share/fonts/chinese/
```

windows 的字体文件位置在
```
C:\Windows\Fonts
```
可以这里的字体一股脑全弄到/usr/share/fonts/chinese/ 这个目录里面。 这个文件夹很大，具体怎么传自己想办法



##### 上传完之后，编辑字体配置
```
vim /etc/fonts/fonts.conf
```
找到
```
<dir prefix="xdg">fonts</dir>
```
在这一行**上面一行**加入
```
<dir>/usr/share/fonts/chinese</dir>
```

##### 刷新字体缓存
```
ttmkfdir -e /usr/share/X11/fonts/encodings/encodings.dir
fc-cache
```

再执行截图， 此时字体就正常了
```
google-chrome-stable --headless --disable-gpu --screenshot --no-sandbox --window-size=800,600 https://www.baidu.com
```
-------
个别没有安好情况下访问微博主页的截图会白屏, 这时候可以利用远程调试来查看报错
```
google-chrome-stable --headless --disable-gpu --no-sandbox --window-size=800,600 --remote-debugging-address=10.123.123.123  --remote-debugging-port=9222 https://www.weibo.com   
```
个别没有安好的情况下访问微博主页会崩溃， 这时候可以dump一下崩溃的log
```
google-chrome-stable --headless --disable-gpu --screenshot --no-sandbox --window-size=800,600 --repl --crash-dumps-dir=./tmp    https://www.baidu.com
```
个别老旧机器启动会报错
```
[root@localhost headless-chrome]# google-chrome-stable --headless --disable-gpu --screenshot --no-sandbox --window-size=800,600 https://www.baidu.com
/bin/google-chrome-stable: symbol lookup error: /bin/google-chrome-stable: undefined symbol: gtk_widget_get_scale_factor
```
优先考虑gtk3 版本过低的问题

执行下面的命令升级一下gtk3
```
yum update gtk3
```

chrome 调试地址：

chrome://inspect/#devices


------
>参考文档


https://developers.google.com/web/tools/chrome-devtools/remote-debugging/webviews


https://chromium.googlesource.com/chromium/src/+/lkgr/headless/README.md

https://developers.google.com/web/updates/2017/04/headless-chrome

chrome协议     https://chromedevtools.github.io/devtools-protocol/

>Spacial thanks
https://intoli.com/blog/installing-google-chrome-on-centos/
