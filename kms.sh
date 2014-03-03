#!/bin/bash

# @version 3.1 since Jul-08-2013
# @author Andrii Lundiak aka alundiak aka @landike

# @description : Bash script to implement most used operations during KMS project development.

#
# @Usage
#

# kms 												<= (cd to trunk folder)
# kms updateMe 											<= (update kms.sh)
# kms diffMe [file]										<= (make svn diff for kms.sh, or provided file)
# kms commitMe ["Commit message for kms.sh"] 							<= (commit kms.sh script)
# kms up 											<= (go to trunk folder and do svn up)
# kms svnR [ 705 | 710:720 ]
# kms [ base | ext | theme | layout | all ]
# kms go 											<= (KMS Dev Env startup (redmine, tomcat, chrome)
# kms modules: [module1,module2,module3,moduleN]						<= (Multiple KMS mudules deployment. "," separated ONLY !!!)
# kms base [ sb | lang ]
# kms db [ backup | restore | start | stop | restart | restore -m | replace_hms_users ]
# kms node [ install | install -proxy | uninstall | uninstall -proxy ]
# kms grunt [ build | clear | setup ]								<= When u need to rebuiuld grunt or clear all node_modules or setup them again.
# kms redmine [ start | stop | restart ]
# kms ip											<= get IP of machine where script is laucnhed. Typing ifconfig is booooring :)	
# kms chrome (run Chrome on Incognito mode)
# kms proxy [ setup | reset ]
# kms 7zip 											<= (possible usage on other Linux machines)


#
## Define Main Root folders to be CWD when/if needed.
#
KMS="/home/developer/workspace/HMS_KMS/"
LIFERAY_TOMCAT="/home/developer/programs/liferay-portal-6.1.0-ce-ga1"

#
## Include another bash script with CONSTANTS - CONFIGURATION items
#
source ${KMS}/kms_config.sh

#
## Change directory to be safe that u working in trunk only.
#
if [ "$1" != "vm" -a "$3" != "copyTo" ]; then
cd $KMS_TRUNK;
fi

#
## Include another bash script with Helper functions
#
source ${KMS}/kms_func.sh

##
## MAIN INPUT POINT in this script. Switching between values in $1 script decides what to do next
##

case $1 in

	"updateMe")
		cd $KMS;
		svn up kms.sh kms_func.sh kms_config.sh kms
		#KMS_MAN_PAGE install kms
		cd $KMS_TRUNK;  # to avoid update in svn root
	;;

	"diffMe")
		cd $KMS
		if [ "$2" ]; then
			if [ -F "$2" ]; then
				svn diff "$2"
			else
				echo "$bldred Provided input: '$2' is not valid file. Please try again.$txtrst"
			fi
		else
			svn diff $KMS_SH $KMS_FUNC_SH $KMS_CONFIG_SH
		fi
		cd $KMS_TRUNK;  # to avoid update in svn root
	;;

	"commitMe")
		cd $KMS; 
		if [ "$2" != "" -a "$3" == ""  ]; then
			echo `svn ci $KMS_SH $KMS_FUNC_SH $KMS_CONFIG_SH "$KMS/kms" -m "$2"`
		elif [ "$3" != "" ]; then
			echo "$txtbld Please wrap your comment by quotes, and try commit again $txtrst"
		else
			echo "$txtbld Please provide text to use as commit message $txtrst"
		fi
		cd $KMS_TRUNK; # to avoid update in svn root
	;;

	"up") 
		kms updateMe		

		cd $KMS_TRUNK;
	
		svn up
	
		npm install # Keep Node Modules up to date
	;;

	"svnR") #$2 = 710:720 -> will be shown histroy of revisions
		cd $KMS_TRUNK;
		if [ -n "$2" ] 
		then 
		 	svn log -r "$2" -v
		else
		 	svn log -r HEAD -v
		fi
	;;

	"git")
		# TBD
	;;

	"go")
		kms up			
		kms redmine start
		sleep 20
		kms tomcat start
		
		#TBD
		#sleep 40
		#kms chrome
		#Chrome is starting ... 
		#failed to create drawable
		# [6120:6120:0513/055847:ERROR:layout.cc(160)] Not implemented reached in ui::ScaleFactor ui::GetScaleFactorForNativeView(GtkWidget*)

		#sleep 10
		#kms eclipse
		#TBD
	;;
	
	"base" | "ext" | "layout" | "theme" | "modules:" | "all" )
		KMS_Modules "$1" "$2"
	;;
	# kms db backup
	# kms db restore
	# kms db restore -m | Manually select file to restore
	# kms db stop
	# kms db start
	# kms db restart
	# kms db replace_hms_users
	"db") 
		cd $KMS_DB_BACKUP 

		if [ "$2" == "restore" ]; then
			KMSRestore "db" "$3";
		elif [ "$2" == "backup" ]; then
			DB_Backup
		elif [ "$2" == "replace_hms_users" ]; then
			DB_Replace_HMS_Users;
		else
			sudo service postgresql-9.1 "$2" # (start, stop, restart)	
		fi
	;;

	"tomcat" )
		# $2 = tmp_del | start | stop | restart | data_backup | data_restore | alive
		# $3 = -withReindex | {port} | -m | -liferay | -catalina
		KMS_Tomcat "$2" "$3"

	;;
	"log") #DEPRECATED
		KMS_Tomcat "$1" "$3"
	;;

	"node") #$2 install | uninstall | update | TBD 
		#$3 with_proxy = to use proxy in console to proceed with yum instalation

		if [ -n "`npm -v`" ]; then
			echo "Node.JS is already installed. Version: `node -v`"; 	
			echo "NPM version: `npm -v`"; 	
			echo "For more detail hit 'npm -l'"
			
		fi

		KMS_NodeJS "$2" "$3"
	;;

	"grunt") # $2 = build | install | clear | setup
		KMS_GruntJS "$2"
	;;

 
	"redmine") # $2: start | stop | restart
		sudo $REDMINE_SCRIPT "$2"
		echo -e "$bldred Redmine action '$2' is done $txtrst"
	;;
	
	"ip")
		ifconfig | grep "inet addr:"
	;;

	"chrome")
		if [ "$2" == "inc" ]; then
			$CHROME %U --disk-cache-size=0 --media-cache-size=0 --incognito --allow-file-access-from-files  --disable-web-security
		else
			$CHROME
		fi
		echo "$bldred Chrome started $txtrst"
	;;

# NEED MORE TESTING
	"proxy") # $2 => [setup | reset]
		SSProxy "$2"
	;;
# NEED MORE TESTING

	"7zip") 
		# http://www.thegeekstuff.com/2010/04/7z-7zip-7za-file-compression/
		# if no 7za you have to install p7zip
		# to check type "whereis 7za"
		su
		SSProxy reset
		SSProxy setup
		yum install 7pzip
	;;

	"vm")
		# $2 = [ qa | trunk | jenkins ]
		# $3 = [ stop | start | restart | log | copyTo | db ]			
		# $4 = fileToCopy
		# $5 = destFolder							

		kmsRemoteEnv="$2"
		kmsAction="$3"
		kmsFile="$4" # or db options: [stop | start | restart | restore | backup]
		kmsDest="$5" # or db option: dump for restoring or... TODO

		if [ "$kmsAction" ];then
			RemoteActions $kmsRemoteEnv $kmsAction $kmsFile $kmsDest
		else 
			RemoteActions $kmsRemoteEnv
		fi

	;;
	
	"vmX")
# kms vmX (need more testing)
		# Extended function to execute terminal in X11 forwading mode. 
		# In this case you will be able to run X-es - any sofftware which need GUI
		# Examples: nautilus, firefox, gnome-terminal, etc.
		# Software will be executed locally but with acces to remote server file structure

		kmsRemoteEnv="$2"
		
		RemoteActions $kmsRemoteEnv "-X"
	;;

esac

if [ "$1" != "vm" -a "$3" != "copyTo" ]; then	
cd $KMS_TRUNK
fi
# I remember that because cd was not being executed from withing kms.sh I started to use kms instead of $0 and changed .bashrc.

