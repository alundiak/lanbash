#!/bin/bash
# http://stackoverflow.com/questions/8529181/which-terminal-command-to-get-just-ip-address-and-nothing-else
echo `ipconfig getifaddr en0` # local IP

# http://hints.macworld.com/article.php?story=20100109053441706
for IP in $*
do
    echo ${IP}
    curl -s http://www.geoiptool.com/en/?ip=${IP} | textutil -convert txt -stdin -stdout -format html | sed -n '/Host Name/,/Postal code/p' 

    # curl -s "http://www.geoiptool.com/en/?IP=${IP}" | 
    # textutil -stdin -format html -stdout -convert txt | 
    # sed -n "/Host Name/,/Postal code/p"

    curl ipinfo.io/${IP}
    # {
    #   "ip": "89.70.34.19",
    #   "hostname": "89-70-34-19.dynamic.chello.pl",
    #   "city": "Krakow",
    #   "region": "Lesser Poland Voivodeship",
    #   "country": "PL",
    #   "loc": "50.0833,19.9167",
    #   "org": "AS6830 Liberty Global Operations B.V.",
    #   "postal": "30-348"
    # }%                            


    # https://www.maketecheasier.com/ip-address-geolocation-lookups-linux/
    curl freegeoip.net/xml/${IP}


done