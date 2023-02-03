#!/bin/bash
# set -x
dnf update -y
wget https://raw.githubusercontent.com/Enkidu-6/snowflake/main/docker-compose.yml
dnf install yum-utils -y
dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
dnf remove podman buildah -y
dnf install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
systemctl enable --now docker.service
echo -e "\033[1;32m"
docker -v
docker compose version
echo -e "\033[1;37m"
echo "If you see a version number above, the installation was successful"
echo "Opening ports for an unrestricted NAT instance of snowflake"
firewall-cmd --permanent --add-port=10000-65000/udp
firewall-cmd --reload
echo "Starting snowflake ...."
echo -e "\033[0m"
docker compose up -d
