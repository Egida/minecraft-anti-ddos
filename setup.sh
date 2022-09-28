#!/bin/bash

# created by oqo0 | 2022

# Allow traffic to your Minecraft port only from whitelisted countries.
# Check scripts/geo_protection.sh first.
geo_whitelist_enabled=false

# Please check scripts/experimental_protection.sh before enabling.
# Disabled by default because it might cause some problems with incoming minecraft connections.
enable_experimental_protection=false


echo "Installing dependencies."
apt -y -qq install curl iptables-persistent ipset conntrack
yum -y install curl iptables-service ipset-service conntrack


echo "Blocking dangerous \ invalid packets."
./scripts/activity_protection.sh

echo "Enabling traffic limitations \ protection."
./scripts/traffic_protection.sh

if [ "$geo_whitelist_enabled" = true ] ; then
    echo "Enabling geo filter."
    ./scripts/geo_protection.sh 
fi

if [ "$enable_experimental_protection" = true ] ; then
    echo "Enabling experimental protection."
    ./scripts/experimental_protection.sh
fi


echo "Saving rules."
iptables-save > /etc/sysconfig/iptables
iptables-save > /etc/iptables/rules.v4