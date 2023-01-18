#!/bin/bash
# set -x
for i in `ls /var/lib/docker/containers`;
do
cd /var/lib/docker/containers/$i
/bin/rm -r $i-json.log
touch $i-json.log
chmod 640 $i-json.log
done;
