#!/bin/bash
# set -x
for i in `ls /var/lib/docker/containers`;
do
cd /var/lib/docker/containers/$i
cat $i-json.log | grep -v ' ERROR' > 1
mv -f 1 $i-json.log
chmod 640 $i-json.log
done;
