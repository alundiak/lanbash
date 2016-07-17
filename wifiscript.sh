#! /usr/bin/env bash
 
### setup some variables
# Copied from https://discussions.apple.com/thread/6619286?start=15&tstart=0
 
wifiInterface="en0" # changed from en2 to en0, coz in my case, en0 has 192.168.0.12
wifiIP=$(ipconfig getifaddr "$wifiInterface")
 
echo "Watching" $wifiInterface "on" $wifiIP
 
while true; do
 
### getting the IP address inside the loop protects against DHCP changes
  wifiIP=$(ipconfig getifaddr "$wifiInterface")
 
### print the date to the terminal window
  echo -n "$(date ) via $wifiIP : " 
 
### write to the syslog that we're trying dig
  syslog -s -k Facility com.apple.console Level Error Sender Wifiscript Message "dig attempt via "$wifiIP" "
 
  dig @8.8.8.8 -b "$wifiIP" +tries=1 +time=3 google.com | \
          grep 'Query time' | \
          cut -d ' ' -f 4 -f 5
 
  if [ ${PIPESTATUS[0]} -ne 0 ] ; then
     echo " "
     echo "*** WIFI ERROR #1 DETECTED -- Trying again ***"
     syslog -s -k Facility com.apple.console Level Error Sender Wifiscript Message "*** WIFI ERROR #1 DETECTED -- Trying again ***"
 
### a second attempt is made in case there's some external issue that caused the first dig to fail
 
### print the date to the terminal window
     echo -n "$(date ) via $wifiIP : " 
 
### write to the syslog that we're trying dig
     syslog -s -k Facility com.apple.console Level Error Sender Wifiscript Message "dig attempt via "$wifiIP" "
 
     dig @8.8.8.8 -b "$wifiIP" +tries=1 +time=3 google.com | \
          grep 'Query time' | \
          cut -d ' ' -f 4 -f 5
 
    if [ ${PIPESTATUS[0]} -ne 0 ] ; then
        echo "*** WIFI ERROR #2 DETECTED ***"
        syslog -s -k Facility com.apple.console Level Error Sender Wifiscript Message "*** WIFI ERROR #2 DETECTED ***"
 
        echo "   . Bringing "$wifiInterface" down and waiting five seconds..."
        syslog -s -k Facility com.apple.console Level Error Sender Wifiscript Message "---> Bringing "$wifiInterface" down and waiting five seconds"
        ifconfig "$wifiInterface" down
        sleep 5
 
        echo "   . Turning off Airport and waiting five seconds..."
        syslog -s -k Facility com.apple.console Level Error Sender Wifiscript Message "---> Turning off Airport and waiting five seconds"
        networksetup -setairportpower "$wifiInterface" off
        sleep 5
 
        echo "   . Turning on Airport and waiting five seconds..."
        syslog -s -k Facility com.apple.console Level Error Sender Wifiscript Message "---> Turning on Airport and waiting five seconds"
        networksetup -setairportpower "$wifiInterface" on
        sleep 5
 
        echo "   . Bringing "$wifiInterface" up and waiting five seconds..."
        syslog -s -k Facility com.apple.console Level Error Sender Wifiscript Message "---> Bringing "$wifiInterface" up and waiting five seconds"
        ifconfig "$wifiInterface" up
        sleep 5
 
        echo "*** WIFI RECOVERY ATTEMPT COMPLETED ***"
        syslog -s -k Facility com.apple.console Level Error Sender Wifiscript Message "*** WIFI RECOVERY ATTEMPT COMPLETED ***"
   fi
  fi
 
### pause for five minutes
  sleep 300
 
done