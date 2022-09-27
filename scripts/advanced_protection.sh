#!/bin/bash

# block packets with bogus tcp flags
iptables -A PREROUTING -p tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG NONE -j DROP
iptables -A PREROUTING -p tcp --tcp-flags FIN,SYN FIN,SYN -j DROP
iptables -A PREROUTING -p tcp --tcp-flags SYN,RST SYN,RST -j DROP
iptables -A PREROUTING -p tcp --tcp-flags FIN,RST FIN,RST -j DROP
iptables -A PREROUTING -p tcp --tcp-flags FIN,ACK FIN -j DROP
iptables -A PREROUTING -p tcp --tcp-flags ACK,URG URG -j DROP
iptables -A PREROUTING -p tcp --tcp-flags ACK,FIN FIN -j DROP
iptables -A PREROUTING -p tcp --tcp-flags ACK,PSH PSH -j DROP
iptables -A PREROUTING -p tcp --tcp-flags ALL ALL -j DROP
iptables -A PREROUTING -p tcp --tcp-flags ALL NONE -j DROP
iptables -A PREROUTING -p tcp --tcp-flags ALL FIN,PSH,URG -j DROP
iptables -A PREROUTING -p tcp --tcp-flags ALL SYN,FIN,PSH,URG -j DROP
iptables -A PREROUTING -p tcp --tcp-flags ALL SYN,RST,ACK,FIN,URG -j DROP

# block spoofed packets
iptables -A PREROUTING -s 224.0.0.0/3 -j DROP
iptables -A PREROUTING -s 169.254.0.0/16 -j DROP
iptables -A PREROUTING -s 172.16.0.0/12 -j DROP
iptables -A PREROUTING -s 192.0.2.0/24 -j DROP
iptables -A PREROUTING -s 192.168.0.0/16 -j DROP
iptables -A PREROUTING -s 10.0.0.0/8 -j DROP
iptables -A PREROUTING -s 0.0.0.0/8 -j DROP
iptables -A PREROUTING -s 240.0.0.0/5 -j DROP
iptables -A PREROUTING -s 127.0.0.0/8 ! -i lo -j DROP