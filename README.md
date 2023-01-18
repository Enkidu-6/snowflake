# snowflake
These are just a few scripts I put together for my personal use. I'm sharing them just in case others might find them useful.

I run 5 to 7 snowflake proxies at each IP address. **docker-compose.yml** is just a sample file to allow you to do the same. If you have 2 CPUs and about 3 GB of RAM you can easily run 5 proxies if not more. From the same directory as docker-compose.yml run:

```
docker compose -d
```
or if you're running the old version of compose on Ubuntu.
```
docker-compose -d
```

Proxies with unrestricted NAT are most useful and will relay the most traffic. In order to run as unrestricted you must open ports in your firewall to allow traffic to a range of UDP ports. 

Depending on the firewall you use these are just a couple of examples

```
firewall-cmd --permanent --add-port=10000-60000/udp
```
```
ufw allow 10000:60000/udp
```
etc...

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
