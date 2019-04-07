cd /usr/local

wget  https://nodejs.org/dist/v10.15.3/node-v10.15.3-linux-x64.tar.xz

tar -xvf node-v10.15.3-linux-x64.tar.xz

rm -f -r node-v10.15.3-linux-x64.tar.xz

mv node-v10.15.3-linux-x64 nodejs

#配置环境变量
echo 'export NODE_HOME=/usr/local/nodejs' >> /etc/profile

echo 'export PATH=$NODE_HOME/bin:$PATH' >> /etc/profile

source /etc/profile

#安装淘宝镜像
npm install -g cnpm --registry=https://registry.npm.taobao.org

npm install pm2 -g
#配置pm2全局变量
ln -s /usr/local/src/node-v10.15.3-linux-x64/bin/pm2  /usr/local/bin/pm2
 
node -v

npm -v

