#!/bin/bash

#      __   __               _                   
#  ___/ /__/ /__  ___   ____(_)__  ___  ___ ____ 
# / _  / _  / _ \(_-<  / __/ / _ \/ _ \/ -_) __/ 
# \_,_/\_,_/\___/___/ /_/ /_/ .__/ .__/\__/_/    
#                          /_/  /_/              
#
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
# Important!
# If you have already ran this script and you want to make some changes to protection, run ./tear-down
# script first.


######################################################################################################

# Max amount of connections that can be established from and ip at the same time.
max_established_connections=10

# Max amount of new connections allowed in 1 minute.
max_connections_per_second=80

# Rcon port you are using. Don't change this if you don't use rcon.
rcon_port=999999


# Allow traffic to your Minecraft port only from whitelisted countries.
geo_whitelist_enabled=false

# Your Minecraft port.
geo_minecraft_port=25565

# Whitelisted countries
# Uses country TLD: https://gist.github.com/oqo0/47a185af30c966a362dbdfebf3771400
geo_whitelist_countries="us,uk,fr,de"


# Please check scripts/advanced_protection.sh before enabling
# Disabled by default because it might cause some problems with incoming minecraft connections.
enable_advanced_protection=false

######################################################################################################


echo "Installing dependencies."
apt -y -qq install curl iptables-persistent ipset conntrack > /dev/null
yum -y install curl iptables-service ipset-service conntrack > /dev/null


# Block dangerous activity
./scripts/activity_protection.sh

# Traffic protection
./scripts/traffic_protection.sh $max_established_connections $max_connections_per_second $rcon_port

# Geo protection
if [ "$geo_whitelist_enabled" = true ] ; then
    ./scripts/geo_protection.sh $geo_minecraft_port $geo_whitelist_countries 
fi

# Blocks somhow-invalid \ dangerous traffic.
if [ "$enable_advanced_protection" = true ] ; then
    ./scripts/advanced_protection.sh
fi


iptables-save > /etc/sysconfig/iptables
iptables-save > /etc/iptables/rules.v4