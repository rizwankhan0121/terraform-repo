#!/bin/bash

    sudo yum -y install httpd
    sudo systemctl daemon-reload
    sudo systemctl enable httpd
    sudo systemctl start httpd
    sudo yum install -y mod_ssl
    cat <<EOF | sudo tee /etc/pki/tls/private/apache-selfsigned.key
    -----BEGIN PRIVATE KEY-----
MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQC94bE5vfPKEYok
A4r4lb6ewEjyg8ZvG9/2msOco7Y510vO0R6+uO661KRavHszHAMDCzShXE4TjmZf
zbAJ9eqyPjB924Vm9k+P4QDfOm7fbep/u8Irh0Zuffqs+Wn2Tq0e0MyF9vJvDAwr
TZJzCRYPs2l/MPodtTtiT7P8A2DF6qBEnEsx8gUcycwLSfokiPsZqQVsjkBh9bTM
SKutC2FVDh8a3tPIEjLmPjyymizBBn1ANTpD1AkGVml7S8b90OD5VuUsHHj6I+IF
T1bAoKPfyqdlaXeTAsaI5JE33F8NPdto5P8VYkvIcvNrWu8XicGmatUk74c1cUEX
8+aAqXpXAgMBAAECggEAIisHqh1NTjJDymE806iWiZiOR92AiqPYdFa7Fme7NcNR
J+EniChdBQ+Yl59NCBBlVlng2ZxzjD9Wmqy3ncM7vWFFdpBW/AUcogZaEtE//EKa
LOwLb6vC98UBo7ip4aGcs2vdMcoTK/peAjjOPpcG+kJNnI6io0/mZLV07Mdq1ZIn
2FnUCnF1kHZk090coLonkzbUIlsqzVvb+3LRoqhekDLkXOdNh1vX0oosRsAfrdtK
MvdrV1gDX49yBmpjIdDHtrphS2kbQQn8bPLIlEqfA/y4qevIRYRh+U/8CP6iwaYg
PciHiZlbClFot9JWZhRegBSUQ8cay7xhfYRPaioCwQKBgQD5rtGx6t/U7JxdvfnP
QG86+H6Q0rUlSNbeQEPN38s+Fe/qJDkUM+AvQqnUDZXXBuMWlQ30VyvvBCDxOh9j
Cz1TUfLqXp82t/hKd/MsPu1XGsPKgkDH75Ssp8n7mA1kVFfw0nV1G7bDkoZRfhSj
dblPczzAbwEPvRbBgfQAddhndwKBgQDCr4s/NMKxstZrc+OjveZL5eUR3rLacN7m
tmssZTR5zg3OKOiDG7sSwtE87UB0xQlJDbcPEvEGMtwms5CEPo45MxQB+IbyoZIh
KMiFF3VGKEJDT/37kNWBoKHyXELRTDAjPzgA40UZz9g0Z/GyBMj83AsPCYUr4xY+
ghkPNi38IQKBgQD2vOfEppLjW596k85WHRrOb9rDSzZvzfdoUqGuxUWX6R3ZiEpP
yKP2kC47u+EjSU8IdewAVlS4MqBLQmDaA7VqrUUcjr1P2aWoEblhNB5fQbfSW72g
1wVZSca0tqIlT6RH+/LO88A8rIPH7IyArEmgVgTnNcsavoXKXJ3ABrUAKQKBgBUz
isWCWGWDpUgkYbj2ODsxuQV+LBoPyqZzXS6Dgvh00RoPaGrGvVOotaKd77QHtSAo
hzP0Cx1ysnjgey97pH9kKZyhVQjdQY2s5FFiIZpXTggIkQ8xUZ8BQEGlfH1Qf7mG
6/FkzqSl9tSWMUMCtGSdDfNARSlnXIfIITR/4PghAoGAba5lDoxKw4Df50x3NBnu
yLIeS6SvuwrFQY+kh1Yb1TSfoi4XdHrMDM8udUJsRIEZxum148urdlN7YrnX3n9z
Etv1buQNkrn+/iF2dpMJ6O2GaXB6lQURJ5kkjVfzTrlOuRD+sLKtpNjx00XeR6cI
XIVdnD4YrrqpMtN53Uvma1I=
-----END PRIVATE KEY-----
EOF
cat <<EOF | sudo tee /etc/pki/tls/certs/apache-selfsigned.crt
-----BEGIN CERTIFICATE-----
MIIEKzCCAxOgAwIBAgIJAI16sOV4WILkMA0GCSqGSIb3DQEBCwUAMIGrMQswCQYD
VQQGEwJHQjEQMA4GA1UECAwHQnJpc3RvbDEQMA4GA1UEBwwHQnJpc3RvbDELMAkG
A1UECgwCQlQxCzAJBgNVBAsMAklUMTYwNAYDVQQDDC10ZXN0YWxiLTE0MDkwNzc4
MC5ldS13ZXN0LTIuZWxiLmFtYXpvbmF3cy5jb20xJjAkBgkqhkiG9w0BCQEWF3Jp
endhbi5zYWlyYWJAZ21haWwuY29tMB4XDTIyMDgyMzIwNDIyMloXDTIzMDgyMzIw
NDIyMlowgasxCzAJBgNVBAYTAkdCMRAwDgYDVQQIDAdCcmlzdG9sMRAwDgYDVQQH
DAdCcmlzdG9sMQswCQYDVQQKDAJCVDELMAkGA1UECwwCSVQxNjA0BgNVBAMMLXRl
c3RhbGItMTQwOTA3NzgwLmV1LXdlc3QtMi5lbGIuYW1hem9uYXdzLmNvbTEmMCQG
CSqGSIb3DQEJARYXcml6d2FuLnNhaXJhYkBnbWFpbC5jb20wggEiMA0GCSqGSIb3
DQEBAQUAA4IBDwAwggEKAoIBAQC94bE5vfPKEYokA4r4lb6ewEjyg8ZvG9/2msOc
o7Y510vO0R6+uO661KRavHszHAMDCzShXE4TjmZfzbAJ9eqyPjB924Vm9k+P4QDf
Om7fbep/u8Irh0Zuffqs+Wn2Tq0e0MyF9vJvDAwrTZJzCRYPs2l/MPodtTtiT7P8
A2DF6qBEnEsx8gUcycwLSfokiPsZqQVsjkBh9bTMSKutC2FVDh8a3tPIEjLmPjyy
mizBBn1ANTpD1AkGVml7S8b90OD5VuUsHHj6I+IFT1bAoKPfyqdlaXeTAsaI5JE3
3F8NPdto5P8VYkvIcvNrWu8XicGmatUk74c1cUEX8+aAqXpXAgMBAAGjUDBOMB0G
A1UdDgQWBBQocb1w6RtTNLuqC0cJ9MCRXu8B2TAfBgNVHSMEGDAWgBQocb1w6RtT
NLuqC0cJ9MCRXu8B2TAMBgNVHRMEBTADAQH/MA0GCSqGSIb3DQEBCwUAA4IBAQBY
IQrs9QJ3+0C+mrwZlftjhPFwK2J0wEbNGGlQ11gJ+MabJi2ZhNf+xbQ4r1Vy/oBs
i9GnzbyJ0z9HpJHGeGojVTrk+y+UrBoiZVmxQcUYsWXd2ceQm2FNmLs+Io36wMDa
E3XIO1B77Un26Lz2EnfdCJS+jvBfNCuWfXOY4Vq/Na/nvPt34Qr2vOZs+2eGoMiN
ibNVg7v+5KBZg3n/VpuzmboCyBrRZFW0Js1QkCRhNUK/5pWxhUQqVx0GFQP2JsWc
VxJQ37NsGsv6kYDXGKFDQQFM7L9jQS2V5FG7NYDon2gHfR7Tyh2KpPIteYXiDg0f
wqlBdEfshzEDB4wDMaIz
-----END CERTIFICATE-----
EOF
cat <<EOF | sudo tee /etc/httpd/conf.d/testalb-140907780.eu-west-2.elb.amazonaws.com.conf
<VirtualHost *:443>
    ServerName testalb-140907780.eu-west-2.elb.amazonaws.com
    DocumentRoot /var/www/html
    SSLEngine on
    SSLCertificateFile /etc/pki/tls/certs/apache-selfsigned.crt
    SSLCertificateKeyFile /etc/pki/tls/private/apache-selfsigned.key
</VirtualHost>
EOF 
    sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
    sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
    sudo amazon-linux-extras install epel -y 
    sudo amazon-linux-extras install java-openjdk11 -y
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
#sudo systemctl start minikube
#kubectl apply -f /home/ec2-user/cri-dockerd/calico-typha.yaml
