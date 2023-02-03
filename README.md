# How to install docker and run a tor snowflake proxy
If you want to run a snowflake proxy but don't know where to start or how to go about installing docker, docker compose and snowflake I've put together a few scripts to make it easy for you.

All you need is a linux operating system and these scripts. They will remove any old versions if exist and install the newest versions of docker and docker compose on your system and you'll be ready to run a snowflake proxy in minutes. 

Download any of the scripts below according to your OS by opening the termial and typing:
```
bash <(curl -s https://raw.githubusercontent.com/Enkidu-6/snowflake/main/script_name.sh)
```

***You must either be root or use sudo to run them***

For:
- Debian Bullseye 11 (stable)
- Debian Buster 10 (oldstable)
- Raspbian Bullseye 11 (stable)
- Raspbian Buster 10 (oldstable)

```
bash <(curl -s https://raw.githubusercontent.com/Enkidu-6/snowflake/main/docker-debian.sh)
```

For:
- Ubuntu Kinetic 22.10
- Ubuntu Jammy 22.04 (LTS)
- Ubuntu Focal 20.04 (LTS)
- Ubuntu Bionic 18.04 (LTS)

```
bash <(curl -s https://raw.githubusercontent.com/Enkidu-6/snowflake/main/docker-ubuntu.sh)
```

For:
CentOS 7

```
bash <(curl -s https://raw.githubusercontent.com/Enkidu-6/snowflake/main/docker-centos.sh)
```

For Almalinux 8

```
bash <(curl -s https://raw.githubusercontent.com/Enkidu-6/snowflake/main/docker-almalinux.sh)
```

**This script removes Podman for Almalinux as it's incompatible with docker.**

**docker-compose.yml** is just a sample file that will allow you to run 5 snowflake proxies on your system simultanuosly. If you have 2 CPUs and about 3 GB of RAM you can easily run 5 proxies if not more. You can use this file or [the official Tor project docker-compose.yml](https://gitlab.torproject.org/tpo/anti-censorship/docker-snowflake-proxy/raw/main/docker-compose.yml) which will run one snowflake proxy.


Proxies with unrestricted NAT are most useful and will relay the most traffic. In order to run as unrestricted you must open ports in your firewall to allow traffic to a range of UDP ports. 

The scripts will enable ufw on Debian and Ubunto and open UDP ports from 10000-60000. It does the same with firewall-cmd on CentOS and Almalinux. If you use a different firewall or you have an external firewall, you need to open the ports yourself.

**You're done and you don't need to do anything else. The following scripts are just extra scripts I wrote to help maintain the setup or get additional information.**

**logs.sh** will list your logs one after another. It also ignores any errors in the log and will show you only the hourly connections.

**cleanlogs.sh** can be used for maintainance of logs. It removes all error messages from the logs to make them easier to navigate.

Sometimes docker logs get large even if you set a size limit. Hunting them down and deleting them can be hard and time consuming. **delogs.sh** will simply empty the logs.


**ip.sh** will search your conntrack table for current IP Addresses connected to you. It will sort and clean the list up and do a Geoip search. It will tell you how many IP addresses are connected to you and which countries they're coming from.

In order to be able to run this script you need to have conntrack_nf on your system. If you type:

```
cat /proc/net/conntrack_nf
```
and nothing shows up, you don't have it. Most recent Ubuntu desktop and servers don't. In that case you'll need to install conntrack utilities.
```
apt install conntrack
```
then use **ip2.sh** which is written specifically for conntrack utilities.

If you have more than 400 IP addresses connected to you, the script will not run as it exceeds the API limit. This script is not useful for a Tor Relay or bridge either.

# A word of warning

**Do not go trigger happy with ip.sh. It's using a free API which allows limited use. You are allowed 4 batch searches a minute and the script uses them all in one shot.**
**If you go above that limit, your IP gets banned for a minute. If you hit the one minute limit a few times in a row, you'll get banned for an hour. If you do more, you'll get banned longer.**

**Getting banned may not seem like a big deal but abusing the free API may make the company think twie about providing this free service and that will effect all the people using it. So be nice.**

**Also the Geoip is not done locally. It is done on their server and if too many people do this too many times, there will eventually be a large list of snowflake users on their server that can easily be abused to deanonymize snowflake users.**
**Using it a couple of times a day should be enough to satisfy your curiosity.**
