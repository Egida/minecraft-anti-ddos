#!/bin/bash

# block invalid packets
iptables -t mangle -A PREROUTING -m conntrack --ctstate INVALID -j DROP

# block xmas packets (kamikaze packets)
iptables -t mangle -A PREROUTING -p tcp -m tcp --tcp-flags ALL ALL -j DROP

# block null packets
iptables -t mangle -A PREROUTING -p tcp -m tcp --tcp-flags ALL NONE -j DROP 

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