#!/bin/sh
SERVER_IP=$(hostname -I | cut -d' ' -f1)
sudo systemctl stop firewalld
sudo systemctl disable firewalld
sudo dnf update -y 
sudo dnf install openssl-devel bzip2-devel -y   
sudo dnf install libffi-devel -y 
sudo dnf group install "Development Tools" -y 
sudo dnf install epel-release -y 
sudo dnf install sqlite -y 
sudo dnf install git -y
sudo yum install -y yum-utils
cd /root
wget https://www.python.org/ftp/python/3.10.4/Python-3.10.4.tgz
tar -xzf Python-3.10.4.tgz
cd Python-3.10.4
./configure --enable-optimizations --enable-loadable-sqlite-extensions
make altinstall
cd ..
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
sudo systemctl start docker
git clone https://github.com/Sobolev5/ABC-Service.git
cd ABC*
sed -i "s/1.2.3.4/$SERVER_IP/g" .env.example
mv .env.example .env
docker compose up --build -d
cd interface
python3.10 -m venv env
source env/bin/activate
pip install -r requirements.txt
python manage.py migrate
python manage.py runserver 0.0.0.0:1234