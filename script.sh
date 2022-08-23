#!/bin/bash

    sudo yum -y install httpd
    sudo systemctl start httpd
    sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
    sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
    sudo amazon-linux-extras install epel -y 
    sudo amazon-linux-extras install java-openjdk11 -y
    sudo yum -y install jenkins
   sudo systemctl daemon-reload
   sudo systemctl enable jenkins
   sudo systemctl start jenkins
   cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch
enabled=1
gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
sudo yum install -y kubectl
sudo yum install -y docker
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-latest.x86_64.rpm
sudo rpm -Uvh minikube-latest.x86_64.rpm
sudo yum install -y conntrack
VERSION="v1.24.1"
wget https://github.com/kubernetes-sigs/cri-tools/releases/download/$VERSION/crictl-$VERSION-linux-amd64.tar.gz
sudo tar zxvf crictl-$VERSION-linux-amd64.tar.gz -C /usr/local/bin
rm -f crictl-$VERSION-linux-amd64.tar.gz
sudo yum install -y git
wget https://storage.googleapis.com/golang/getgo/installer_linux
chmod +x installer_linux
./installer_linux
source ~/.bash_profile
git clone https://github.com/Mirantis/cri-dockerd.git
yum install git -y
git clone https://github.com/Mirantis/cri-dockerd.git
cd cri-dockerd
mkdir bin
go build -o bin/cri-dockerd
sudo mkdir -p /usr/local/bin
sudo install -o root -g root -m 0755 bin/cri-dockerd /usr/local/bin/cri-dockerd
sudo cp -a packaging/systemd/* /etc/systemd/system
sudo sed -i -e 's,/usr/bin/cri-dockerd,/usr/local/bin/cri-dockerd,' /etc/systemd/system/cri-docker.service
sudo systemctl daemon-reload
sudo systemctl enable cri-docker.service
sudo systemctl enable --now cri-docker.socket
sudo cp  /usr/local/bin/crictl /usr/bin/
sudo cp /usr/local/bin/cri-dockerd /usr/bin/
sudo systemctl enable docker
sudo systemctl start docker
sudo yum install -y yum-utils
cd /root/
wget https://docs.projectcalico.org/manifests/calico-typha.yaml
cat <<EOF | sudo tee /usr/lib/systemd/system/minikube.service
[Unit]
Description=minikube
After=network-online.target firewalld.service containerd.service docker.service
Wants=network-online.target docker.service
Requires=docker.socket containerd.service docker.service

[Service]
Type=oneshot
RemainAfterExit=yes
WorkingDirectory=/root
ExecStart=/usr/bin/minikube start --driver=none
ExecStop=/usr/bin/minikube stop
User=root
Group=root

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable minikube
sudo systemctl start minikube
kubectl create -f calico-typha.yaml
