#!/bin/bash
#
# Simple script to lookup networking information by possible command we have in Windows environment.
#

id

ifconfig

# TODO: Parse ifconfig results and get IP, or prompt/read user to enter
IP="127.0.0.1"

wifiInterface="en0"
wifiIP=$(ipconfig getifaddr "$wifiInterface")

networksetup -listallhardwareports

tracwroute "$IP"

nslookup "$IP"

echo "Now we will scan wi-fi networks"
# Will scan all wi-fi networks.
# MacBook path
/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport /usr/sbin/airport -s

node wifi.js

# READ this: http://www.infoworld.com/article/2614879/mac-os-x/top-20-os-x-command-line-secrets-for-power-users.html?page=2
