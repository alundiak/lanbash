#!/bin/bash
#
## KMS Environment Deployment script
#

# alundiak:
# Planned to use instead repetitive tasks on KMS environment servers: QA and TRUINK and PROD

TOMCAT="/home/developer/programs/liferay-portal-6.1.0-ce-ga1/tomcat-7.0.23/"
BIN="$TOMCAT/bin/"
TEMP="$TOMCAT/temp/"

case $1 in
	"restart")
		cd $BIN
		./shutdown.sh

		sleep 10

		cd $TEMP
		rm -rf ./*
		echo -e "=========================================\n"
		echo -e "Temporary files from $TEMP folder deleted\n"
		echo -e "=========================================\n"

		cd $BIN
		./startup.sh

		echo -e "=========================================\n"
		echo -e "Tomcat is being started\n"
		;;
	"log")
		tail -f  $TOMCAT"logs/catalina.out"
		;;
	"tomcat")
		cd $TOMCAT
		;;
	*)
		echo "Type 'qatest restart' or 'qatest log'";
		;;
esac
