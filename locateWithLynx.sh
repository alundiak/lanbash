#!/bin/bash
# http://hints.macworld.com/article.php?story=20100109053441706

echo "Put the IPs you want to lookup into a file named list."

url="http://www.geoiptool.com/en/?IP="

for i in `cat locate_ip_list.txt`
do
  lynx -dump $url$i > tmp
  cat tmp | sed -n '/Host Name/,/Postal code/p'
  rm tmp
done
