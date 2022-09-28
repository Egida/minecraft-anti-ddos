#!/bin/bash

ipset destroy country_whitelist
ipset -N -! country_whitelist hash:net maxelem 100000

# get country ip blocks
country_list="https://raw.githubusercontent.com/herrbischoff/country-ip-blocks/master/ipv4/"

# add whitelisted countries to an ipset
for ip in $(curl -L $country_list/{de,us,uk,fr}.cidr);
    do ipset -A country_whitelist $ip
done

# allow connections only from whitelisted countries
iptables -A INPUT -p tcp --dport 25565 -m set --match-set country_whitelist src -j ACCEPT
iptables -A INPUT -p tcp --dport 25565 --syn -j DROP