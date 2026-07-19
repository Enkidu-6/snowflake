/sbin/iptables -t filter -A INPUT -m state --state NEW\,ESTABLISHED -j ACCEPT
/sbin/iptables -t filter -A FORWARD -m state --state NEW\,ESTABLISHED -j ACCEPT
/sbin/iptables -t filter -A OUTPUT -m state --state NEW\,ESTABLISHED -j ACCEPT
/sbin/ip6tables -t filter -A INPUT -m state --state NEW\,ESTABLISHED -j ACCEPT
/sbin/ip6tables -t filter -A FORWARD -m state --state NEW\,ESTABLISHED -j ACCEPT
/sbin/ip6tables -t filter -A OUTPUT -m state --state NEW\,ESTABLISHED -j ACCEPT
