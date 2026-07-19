# Install tor snowflake proxy

https://community.torproject.org/relay/setup/snowflake/standalone/



# IP GEO tracking

**count.sh** will search your conntrack table for current IP Addresses connected to you. It will sort and clean the list up and do a Geoip search. It will tell you how many IP addresses are connected to you and which countries they're coming from.

In order to be able to run this script you need to have conntrack_nf on your system. If you type:

```
cat /proc/net/conntrack_nf
```
and nothing shows up, you don't have it. Most recent Ubuntu desktop and servers don't. In that case you'll need to install conntrack utilities.
```
apt install conntrack
```
```
sh iptables.sh
```
```
sh count.sh
```

# A word of warning

**Do not go trigger happy with count.sh. It's using a free API which allows limited use. You are allowed 4 batch searches a minute and the script uses them all in one shot.**
**If you go above that limit, your IP gets banned for a minute. If you hit the one minute limit a few times in a row, you'll get banned for an hour. If you do more, you'll get banned longer.**

**Getting banned may not seem like a big deal but abusing the free API may make the company think twie about providing this free service and that will effect all the people using it. So be nice.**

**Also the Geoip is not done locally. It is done on their server and if too many people do this too many times, there will eventually be a large list of snowflake users on their server that can easily be abused to deanonymize snowflake users.**

Update: A part of the IP is cut off to maintain some anonymity…

**Using it a couple of times a day should be enough to satisfy your curiosity.**
