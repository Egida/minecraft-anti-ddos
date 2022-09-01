#!/bin/bash

iptables -t mangle -D PREROUTING -m conntrack --ctstate INVALID -j DROP
iptables -t mangle -D PREROUTING -p tcp ! --syn -m conntrack --ctstate NEW -j DROP
iptables -t mangle -D PREROUTING -p tcp -m conntrack --ctstate NEW -m tcpmss ! --mss 536:65535 -j DROP
iptables -t mangle -D PREROUTING -p icmp -j DROP
sudo iptables -N anti-port-scan
sudo iptables -A anti-port-scan -p tcp --tcp-flags SYN,ACK,FIN,RST RST -m limit --limit 1/s -j RETURN
sudo iptables -A anti-port-scan -j DROP
iptables -D INPUT -p tcp -m connlimit --connlimit-above 5 -j REJECT --reject-with tcp-reset
iptables -D INPUT -p tcp -m conntrack --ctstate NEW -m limit --limit 8/s --limit-burst 4 -j ACCEPT 
iptables -D INPUT -p tcp -m conntrack --ctstate NEW -j DROP