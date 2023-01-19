#!/bin/bash
# set -x
yum update
yum install yum-utils
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install docker-ce docker-ce-cli containerd.io docker-compose-plugin
systemctl enable --now docker.service
echo -e "\033[1;37m"
docker -v
docker compose version
echo "If you see a version number above, the installation was successful"
echo -e "\033[0m"
