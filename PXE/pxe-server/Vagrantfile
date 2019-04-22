# -*- mode: ruby -*-
# vi: set ft=ruby :

# Node definition
nodes = [
  {
    :hostname => 'pxe-server',
    :cpus     => 1,
    :memory   => 128,
    :box      => 'centos/7',
    :forwarded_ports => [],
    :synced_folders => [],
    :networks => [
      {
        :ip => '172.16.10.5',
        :netname => 'pxe',
        :auto_config => false,
      },
    ],
  },
]

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  nodes.each do |node|
    config.vm.define node[:hostname] do |node_config|
      node_config.vm.hostname = node[:hostname]
      node_config.vm.box = node[:box]

      node_config.ssh.forward_x11 = true

      node[:forwarded_ports].each do |forwarded_port|
        node_config.vm.network "forwarded_port", guest: forwarded_port[:guest], host: forwarded_port[:host]
      end

      node[:synced_folders].each do |synced_folder|
        node_config.vm.synced_folder synced_folder[:host], synced_folder[:guest]
      end

      node[:networks].each do |network|
        if network[:ip]
          node_config.vm.network "private_network", ip: network[:ip], virtualbox__intnet: network[:netname], auto_config: network[:auto_config]
        end

        if network[:type]
          node_config.vm.network "private_network", type: network[:type], virtualbox__intnet: network[:netname], auto_config: network[:auto_config]
        end

        if network[:promiscuous]
          node_config.vm.provider "virtualbox" do |v|
            v.customize [
              "modifyvm", :id,
              "--nicpromisc#{network[:nic]}", network[:promiscuous]
            ]
          end
        end
      end

      node_config.vm.provider "virtualbox" do |v|
        v.name = node[:hostname]
        v.cpus = node[:cpus]
        v.memory = node[:memory]
      end

      node_config.vm.provision :shell, :path => node[:hostname] + ".sh"
    end
  end
end
