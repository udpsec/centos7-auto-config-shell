#refer:https://kubernetes.io/docs/setup/cri/




# Install Docker CE
## Set up the repository
### Install required packages.
    yum install yum-utils device-mapper-persistent-data lvm2

### Add docker repository.
yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo

## Install docker ce.
yum update && yum install docker-ce-18.06.2.ce -y

## Create /etc/docker directory.
mkdir /etc/docker

# Setup daemon.
cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2",
  "storage-opts": [
    "overlay2.override_kernel_check=true"
  ]
}
EOF

mkdir -p /etc/systemd/system/docker.service.d

# Restart docker.
systemctl daemon-reload
systemctl restart docker


# Prerequisites for CRI-O
modprobe overlay
modprobe br_netfilter

# Setup required sysctl params, these persist across reboots.
cat > /etc/sysctl.d/99-kubernetes-cri.conf <<EOF
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

sysctl --system



# Install prerequisites
yum-config-manager --add-repo=https://cbs.centos.org/repos/paas7-crio-311-candidate/x86_64/os/

# Install CRI-O
yum install --nogpgcheck cri-o -y


#Start CRI-O
systemctl start crio







# Prerequisites for Containerd
modprobe overlay
modprobe br_netfilter

# Setup required sysctl params, these persist across reboots.
cat > /etc/sysctl.d/99-kubernetes-cri.conf <<EOF
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

sysctl --system

yum install -y libseccomp

# Export required environment variables.
export CONTAINERD_VERSION="1.1.2"
export CONTAINERD_SHA256="d4ed54891e90a5d1a45e3e96464e2e8a4770cd380c21285ef5c9895c40549218"

# Download containerd tar.
wget https://storage.googleapis.com/cri-containerd-release/cri-containerd-${CONTAINERD_VERSION}.linux-amd64.tar.gz

# Check hash.
echo "${CONTAINERD_SHA256} cri-containerd-${CONTAINERD_VERSION}.linux-amd64.tar.gz" | sha256sum --check -

# Unpack.
tar --no-overwrite-dir -C / -xzf cri-containerd-${CONTAINERD_VERSION}.linux-amd64.tar.gz

# Start containerd.
systemctl start containerd

