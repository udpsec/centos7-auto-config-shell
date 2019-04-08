sudo yum update -y

sudo curl -sSL https://get.docker.com | sh

curl -sSL https://get.daocloud.io/daotools/set_mirror.sh | sh -s http://f1361db2.m.daocloud.io

systemctl enable docker
systemctl start docker

service docker restart

pip install docker-compose
