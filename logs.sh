#!/bin/bash
# set -x
for i in `docker ps | awk '{print $NF }' | sed -e '1d'`;
do
echo -e "\033[1;32m                    $i\033[1;37m"
docker logs $i | grep 1h0m
echo -e "\033[0m"
read -p "Press Enter to continue" </dev/tty
done;
