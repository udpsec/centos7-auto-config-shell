# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "hzhihua/centos7"

  # 虚拟机hostname
  config.vm.hostname = "centos7"

  # 检查 box 更新
  # 
  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  config.vm.box_check_update = false

  # 端口映射
  # 在本机浏览器输入 http://127.0.0.1:80 映射到虚拟机的 8080端口
  # 可设置多个不同的端口映射，确保本机的服务器软件停止运行
  # 
  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # 设置私有网络，只能本机与虚拟机 或 虚拟机与虚拟机进行访问
  # 在本机浏览器输入 http://192.168.33.10 即可访问虚拟机
  # 
  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # 设置虚拟机网络为公有网络，可以给与本机同一局域网的其他电脑访问
  # @see https://www.vagrantup.com/docs/networking/public_network.html
  # 
  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"
  # config.vm.network "public_network", ip: "192.168.33.11"

  # 设置共享目录，将本机上编辑的脚本程序自动同步到虚拟机上
  # 第一个参数为本机目录  第二个参数为虚拟机目录
  # nginx   需将 sendfile 关闭         sendfile off;
  # apache  需将 EnableSendfile 关闭   EnableSendfile Off;
  # @see https://www.vagrantup.com/docs/synced-folders/virtualbox.html
  # 
  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "/data/wwwroot/default/", "/data/wwwroot/syncedFolder/"

  # 虚拟机的配置 如内存大小，hostname ...
  # 
  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  #   vb.name = "centos7"
  #   vb.cpus = 2
  # end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
  # such as FTP and Heroku are also available. See the documentation at
  # https://docs.vagrantup.com/v2/push/atlas.html for more information.
  # config.push.define "atlas" do |push|
  #   push.app = "YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME"
  # end

  # $ vagrant up --provision-with shell 会执行以下命令
  # @see https://www.vagrantup.com/docs/provisioning/shell.html
  # @see https://www.vagrantup.com/docs/cli/provision.html
  # 
  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   apt-get update
  #   apt-get install -y apache2
  # SHELL
  # config.vm.provision "shell", inline: "echo I am provisioning..."
end
