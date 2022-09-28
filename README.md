# 🔒Minecraft anti-DDOS

Iptables anti-DDOS for Minecraft networks.
Tested on: Bungeecord, Waterfall, Spigot.

> **Warning**
> Before running this script remove existing IPtables rules first. 

This script is free and open for any use and distribution. It is recommended to adjust the following script for yourself in order to achieve the best protection quality.

It is quite important to note that if your hosting provider does not have any common anti-DDOS, then this script will be practically useless.

## Statistics

Test server: Intel Xeon E5-2680V2 1 core, Ubuntu Server 20.04, OpenJDK 8

| Mode  | Max CPU usage | Average CPU usage |
| ------------- | ------------- | ------------- |
| Without protection | 100% | 50% |
| Traffic protection  | 60% | 40% |
| Traffic protection + Geo protection  | 50% | 35% |

## Usage

1) Clone project
```
git clone https://github.com/oqo0/minecraft-anti-ddos.git
```

2) Adjust script for your needs
```
nano setup.sh
```

3) Make script executable
```
chmod +x setup.sh
```

4) Run the script
```
./setup.sh
```