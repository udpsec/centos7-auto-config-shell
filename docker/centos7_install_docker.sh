sudo yum update -y
sudo yum remove docker  docker-common docker-selinux docker-engine
sudo yum install -y yum-utils device-mapper-persistent-data lvm2
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum list docker-ce --showduplicates | sort -r
sudo yum install docker-ce -y
sudo systemctl start docker
sudo systemctl enable docker
docker version