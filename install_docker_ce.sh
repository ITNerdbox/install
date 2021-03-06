#!/bin/bash

apt update
apt upgrade
apt remove docker docker-engine docker.io
apt install apt-transport-https ca-certificates curl gnupg2 software-properties-common

curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -

add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
apt update
apt install docker-ce docker-ce-cli containerd.io docker-compose


groupadd docker
usermod -aG docker $USER
systemctl enable docker
