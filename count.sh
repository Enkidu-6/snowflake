#!/bin/bash
# set -x
mkdir -p ip
echo -e "\033[0;30m"
# every address configured on this box. no NAT here, so both tuples of a line
# are mirror images and this list is the only thing separating us from a peer.
ip -o addr show 2>/dev/null | awk '{split($4,a,"/"); print a[1]}' | sort -u > 0
# skip our own STUN traffic: matched on the ORIGINAL tuple's dport only, so a
# client that happens to pick 3478 as a source port is not thrown away too
PEERS='{p=""; for(i=1;i<=NF;i++) if($i ~ /^dport=/){p=substr($i,7); break}
        if(p=="3478" || p=="5349" || p=="19302") next
        for(i=1;i<=NF;i++) if($i ~ /^(src|dst)=/){split($i,a,"="); print a[2]}}'
conntrack -L -p udp -f ipv4 2>/dev/null | grep ASSURED  > 1
conntrack -L -p udp -f ipv6 2>/dev/null | grep ASSURED > 1v6
cat 1 | awk "$PEERS" | grep -vxF -f 0 | grep -Ev '^(0|10|127)\.|^169\.254\.|^172\.(1[6-9]|2[0-9]|3[01])\.|^192\.168\.|^(22[4-9]|23[0-9]|24[0-9]|25[0-5])\.' | sort -u | sed 's/\.[0-9]*$/.0/' > 2
cat 1v6 | awk "$PEERS" | grep -vxF -f 0 | grep -Evi '^(::|f[cdef])' | sort -u | awk '{if(NF<8){inner = "0"; for(missing = (8 - NF);missing>0;--missing){inner = inner ":0"}; if($2 == ""){$2 = inner} else if($3 == ""){$3 = inner} else if($4 == ""){$4 = inner} else if($5 == ""){$5 = inner} else if($6 == ""){$6 = inner} else if($7 == ""){$7 = inner}}; print $0}' FS=":" OFS=":" | awk '{for(i=1;i<9;++i){len = length($(i)); if(len < 1){$(i) = "0000"} else if(len < 2){$(i) = "000" $(i)} else if(len < 3){$(i) = "00" $(i)} else if(len < 4){$(i) = "0" $(i)} }; print $0}' FS=":" OFS=":" | grep -o ^....:....: | sed 's/:$/::/' >> 2 
# many peers share a prefix, so look each prefix up ONCE and remember how many
# distinct peers were behind it. file 4 is "<prefix>\t<peers>", file 5 the queries.
sort 2 | uniq -c | awk '{print $2 "\t" $1}' > 4
cut -f1 4 > 5
Linenum=`wc -l < 5`
if [ "$Linenum" -lt 5396 ];
then
split -l 100 -d 5 ip/3
else
echo -e "\033[1;37mThe file is too large.\033[0m"
/bin/rm -r -f 0 1 1v6 2 4 5
/bin/rm -r -f ip
exit;
fi
: > 3
for i in `ls ip`;
do
file=$(xargs -a ip/$i | sed 's/ /", "/g' | sed 's/.*/["&"]/')
curl -s -D h 'http://ip-api.com/batch?fields=country' --data "$file" | awk '{s=$0; while(match(s,/\{[^{}]*\}/)){o=substr(s,RSTART,RLENGTH); s=substr(s,RSTART+RLENGTH); if(match(o,/"country":"[^"]*"/) && RLENGTH>12) print substr(o,RSTART+11,RLENGTH-12); else print "(unknown)"}}' > c
if [ "`wc -l < c`" -ne "`wc -l < ip/$i`" ]; then
echo -e "\033[1;37mip-api.com returned the wrong number of results.\033[0m"
/bin/rm -r -f 0 1 1v6 2 3 4 5 c h
/bin/rm -r -f ip
exit;
fi
paste ip/$i c >> 3
# only wait when the window is actually used up (X-Rl 0), per ip-api's docs
rl=`awk 'tolower($1)=="x-rl:" {print $2+0}' h | tail -n1`
ttl=`awk 'tolower($1)=="x-ttl:" {print $2+0}' h | tail -n1`
[ -z "$rl" ] && rl=0 && ttl=60
[ "$rl" -le 0 ] && sleep $((ttl+1))
done;
echo -e "\033[1;37m"
awk -F'\t' 'NR==FNR{co[$1]=$2; next} {k=($1 in co)?co[$1]:"(unknown)"; t[k]+=$2} END{for(k in t) printf "%7d %s\n", t[k], k}' 3 4 | sort -rn
echo -e "\033[0m"
/bin/rm -r -f 0 1v6 1 2 3 4 5 c h
/bin/rm -r -f ip
