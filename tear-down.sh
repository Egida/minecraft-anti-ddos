#!/bin/bash

iptables -t mangle -D PREROUTING -m conntrack --ctstate INVALID -j DROP
iptables -t mangle -D PREROUTING -p tcp ! --syn -m conntrack --ctstate NEW -j DROP
iptables -t mangle -D PREROUTING -p tcp -m conntrack --ctstate NEW -m tcpmss ! --mss 536:65535 -j DROP
iptables -t mangle -D PREROUTING -p icmp -j DROP
iptables -D INPUT -p tcp -m connlimit --connlimit-above 8 -j REJECT --reject-with tcp-reset
iptables -D INPUT -p tcp -m conntrack --ctstate NEW -m limit --limit 10/s --limit-burst 5 -j ACCEPT 
iptables -D INPUT -p tcp -m conntrack --ctstate NEW -j DROP