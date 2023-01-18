#!/bin/bash
# set -x
mkdir ip
echo -e "\033[0;30m"
conntrack -L -p udp | grep ASSURED  > 1
conntrack -L -p udp -f ipv6 | grep ASSURED >> 1
cat 1 | awk '{ print $4 }' | awk -F= '{ print $2 }' | sort | uniq -c | awk '{ print $2 }' > 2
Linenum=`wc -l < 2`
if [ "$Linenum" -lt 396 ];
then
split -l 99 -d 2 ip/3
else
echo -e "\033[1;37mThe file is too large.\033[0m"
fi
for i in `ls ip`;
do
xargs -a ip/$i | sed 's/ /", "/g' | sed "s/.*/\'\[\"&\"\]\'/" > 2-$i
file=$(cat 2-$i)
echo "curl -s http://ip-api.com/batch?fields=1 --data $file | xargs | tr , '\n' >> 3" | bash -
done;
echo -e "\033[1;37m"
cat 3 | sed 's/{country://g' | sed 's/}//;s/{//g' | sed 's/]//g' | sed 's/\[//g' | sort | uniq -c
echo -e "\033[0m"
/bin/rm -r -f 1 2 3 2-300 2-301 2-302 2-303
/bin/rm -r ip
