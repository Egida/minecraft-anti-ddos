#!/bin/bash


# ---------------------------------------------------------
# bloack or limit ununused \ invalid packets 
# ---------------------------------------------------------
# block invalid packets
iptables -t mangle -A PREROUTING -m conntrack --ctstate INVALID -j DROP
# block not syn packets
iptables -t mangle -A PREROUTING -p tcp ! --syn -m conntrack --ctstate NEW -j DROP
# block uncommon MMS values
iptables -t mangle -A PREROUTING -p tcp -m conntrack --ctstate NEW -m tcpmss ! --mss 536:65535 -j DROP
# block all icmp packets
iptables -t mangle -A PREROUTING -p icmp -j DROP
# drop fragments in all chains
iptables -t mangle -A PREROUTING -f -j DROP
# limit rst packets
iptables -A INPUT -p tcp --tcp-flags RST RST -m limit --limit 2/s --limit-burst 2 -j ACCEPT
iptables -A INPUT -p tcp --tcp-flags RST RST -j DROP

# block port scan
sudo iptables -N anti-port-scan
sudo iptables -A anti-port-scan -p tcp --tcp-flags SYN,ACK,FIN,RST RST -m limit --limit 1/s -j RETURN
sudo iptables -A anti-port-scan -j DROP

# block hosts that have more than 10 established connections
iptables -A INPUT -p tcp -m connlimit --connlimit-above 10 -j REJECT --reject-with tcp-reset
# limits the new tcp connections that a client can establish per second
iptables -A INPUT -p tcp -m conntrack --ctstate NEW -m limit --limit 10/s --limit-burst 5 -j ACCEPT 
iptables -A INPUT -p tcp -m conntrack --ctstate NEW -j DROP