#!/bin/bash

# block invalid packets
iptables -t mangle -A PREROUTING -m conntrack --ctstate INVALID -j DROP
# block not syn packets
iptables -t mangle -A PREROUTING -p tcp ! --syn -m conntrack --ctstate NEW -j DROP
# block uncommon MMS values
iptables -t mangle -A PREROUTING -p tcp -m conntrack --ctstate NEW -m tcpmss ! --mss 536:65535 -j DROP
# block all icmp packets
iptables -t mangle -A PREROUTING -p icmp -j DROP

# block hosts that have more than 5 established connections
iptables -A INPUT -p tcp -m connlimit --connlimit-above 5 -j REJECT --reject-with tcp-reset
# limits the new tcp connections that a client can establish per second
iptables -A INPUT -p tcp -m conntrack --ctstate NEW -m limit --limit 8/s --limit-burst 4 -j ACCEPT 
iptables -A INPUT -p tcp -m conntrack --ctstate NEW -j DROP

# port you are running your minecraft server on
minecraft_port=25565