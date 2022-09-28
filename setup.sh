#!/bin/bash

# created by oqo0 | 2022 
# 
# This script is free and open for any use and distribution. It is recommended to adjust the following
# parameters for yourself in order to achieve the best protection quality. This script has been tested
# on servers with hundreds of regular players. If you encounter any problems please create an issue on
# project's Github: https://github.com/oqo0/minecraft-anti-ddos
# 
# It is also quite important to note that if your hosting provider does not have any common anti-DDOS,
# then this script will be practically useless.
#


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