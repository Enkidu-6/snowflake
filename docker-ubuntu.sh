#!/bin/bash
# set -x
wget https://raw.githubusercontent.com/Enkidu-6/snowflake/main/docker-compose.yml
apt-get remove docker docker-engine docker.io containerd runc -y
apt-get update -y
apt-get install ca-certificates curl gnupg lsb-release -y
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
chmod a+r /etc/apt/keyrings/docker.gpg
apt-get update -y
apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
echo -e "\033[1;32m"
docker -v
docker compose version
echo -e "\033[1;37m"
echo "If you see a version number above, the installation was successful"
echo "Opening ports for an unrestricted NAT instance of snowflake"
ufw enable
ufw allow 10000:60000/udp
echo "Starting snowflake ...."
echo -e "\033[0m"
docker compose up -d
