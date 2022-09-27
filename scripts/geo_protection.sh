#!/bin/bash

# get country ip blocks
country_list="https://raw.githubusercontent.com/herrbischoff/country-ip-blocks/master/ipv4/"

# add whitelisted countries to an ipset
for ip in $(curl -L $country_list/{$2}.cidr);
    do ipset -A county_whitelist $ip
done

# allow connections only from whitelisted countries
iptables -A INPUT -m set --match-set county_whitelist src -p tcp --dport $1 -j ACCEPT
iptables -A INPUT -p tcp --dport $minecraft_port -j DROP