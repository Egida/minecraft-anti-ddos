#!/bin/bash

#
# dangerous aactivity
#
# these rules supposed to block invalid \ dangerous traffic
# it is not recommended to remove any rules from here
#

# block invalid packets
iptables -t mangle -A PREROUTING -m conntrack --ctstate INVALID -j DROP
# block xmas packets (kamikaze packets)
iptables -t mangle -A PREROUTING -p tcp -m tcp --tcp-flags ALL ALL -j DROP
# Block null packet
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

# 
# active protection
# 
# the main task of this section is to reduce the load on the server during peak loads
# you can adjust some values
#

# block port scan
sudo iptables -N anti-port-scan
sudo iptables -A anti-port-scan -p tcp --tcp-flags SYN,ACK,FIN,RST RST -m limit --limit 1/s -j RETURN
sudo iptables -A anti-port-scan -j DROP

# block hosts that have more than 10 established connections
iptables -A INPUT -p tcp -m connlimit --connlimit-above 10 -j REJECT --reject-with tcp-reset
# limits the new tcp connections that a client can establish per second
iptables -A INPUT -p tcp -m conntrack --ctstate NEW -m limit --limit 10/s --limit-burst 5 -j ACCEPT 
iptables -A INPUT -p tcp -m conntrack --ctstate NEW -j DROP

# use synproxy on all ports
iptables -t raw -A PREROUTING -p tcp -m tcp --syn -j CT --notrack
iptables -A INPUT -p tcp -m tcp -m conntrack --ctstate INVALID,UNTRACKED -j SYNPROXY --sack-perm --timestamp --wscale 7 --mss 1460
iptables -A INPUT -m conntrack --ctstate INVALID -j DROP

# protect ssh from brute-force
iptables -A INPUT -p tcp --dport ssh -m conntrack --ctstate NEW -m recent --set
iptables -A INPUT -p tcp --dport ssh -m conntrack --ctstate NEW -m recent --update --seconds 120 --hitcount 30 -j DROP

# protect rcon from brute-force
# enter your rcon port or remove this if you don't use it
rcon_port="21000"
iptables -A INPUT -p tcp --dport $rcon_port -m conntrack --ctstate NEW -m recent --set
iptables -A INPUT -p tcp --dport $rcon_port -m conntrack --ctstate NEW -m recent --update --seconds 60 --hitcount 20 -j DROP

# 
# geo protection
# 
# you can use this section to whitelist traffic from specific countries \ regions
# this option is disabled by default
# it is recommended to enable after you change the list of countries to the desired one
#