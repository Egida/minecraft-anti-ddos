#!/bin/bash

# block port scan
iptables -N anti-port-scan
iptables -A anti-port-scan -p tcp --tcp-flags SYN,ACK,FIN,RST RST -m limit --limit 1/s -j RETURN
iptables -A anti-port-scan -j DROP

# block hosts that have more than 6 established connections
iptables -A INPUT -p tcp -m connlimit --connlimit-above 6 -j REJECT --reject-with tcp-reset
# limits the new tcp connections that a client can establish
iptables -A INPUT -p tcp -m conntrack --ctstate NEW -m limit --limit 10/s --limit-burst 8 -j ACCEPT
iptables -A INPUT -p tcp -m conntrack --ctstate NEW -m limit --limit 300/s --limit-burst 30 -j ACCEPT 
iptables -A INPUT -p tcp -m conntrack --ctstate NEW -j DROP

# protect ssh from brute-force
iptables -A INPUT -p tcp --dport ssh -m conntrack --ctstate NEW -m recent --set
iptables -A INPUT -p tcp --dport ssh -m conntrack --ctstate NEW -m recent --update --seconds 120 --hitcount 30 -j DROP

# protect rcon from brute-force
iptables -A INPUT -p tcp --dport $3 -m conntrack --ctstate NEW -m recent --set
iptables -A INPUT -p tcp --dport $3 -m conntrack --ctstate NEW -m recent --update --seconds 60 --hitcount 20 -j DROP