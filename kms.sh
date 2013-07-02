#!/bin/bash

# @version 2.6 since Jun-27-2013
# @author alundiak

# @description
# Bash script to implement most frequently used operations during KMS project development.

# @Usage

# kms 												<= (cd to trunk folder)
# kms updateMe 											<= (update kms.sh)
# kms diffMe 											<= (make svn diff for kms.sh)
# kms commitMe ["Commit message for kms.sh"] 							<= (commit kms.sh script)
# kms go 											<= (KMS Dev Env startup (redmine, tomcat, chrome)
# kms up 											<= (go to trunk folder and do svn up)
# kms svnR [ 705 | 710:720 ]
# kms [ base | ext | theme | layout | all ]
# kms base [ sb | lang ]
# kms log [ -liferay | -tomcat ]
# kms tomcat [ tmp_del | start | stop | restart | data_backup | restore | restore -m ]
# kms db [ backup | restore | start | stop | restart | restore -m ]
# kms node [ install | install -proxy | uninstall | uninstall -proxy ]
# kms grunt [ build | uninstall ]
# kms redmine [ start | stop | restart ]
# kms ip
# kms chrome (run Chrome on Incognito mode)
# kms proxy [ setup | reset ]
# kms 7zip 											<= (possible usage on other Linux machines)
# kms isTomcatAlive										<= (Check if Tomcat PID is alive)
# kms vm [ qa | trunk | jenkins ] [ stop | start | restart | copyTo [fileToCopy] ]		<= (remote work with SS VMs)

# Text color variables
# Details: http://linuxtidbits.wordpress.com/2008/08/11/output-color-on-bash-scripts/
txtund=$(tput sgr 0 1)          # Underline
txtbld=$(tput bold)             # Bold
bldred=${txtbld}$(tput setaf 1) #  red
bldblu=${txtbld}$(tput setaf 4) #  blue
bldwht=${txtbld}$(tput setaf 7) #  white
txtrst=$(tput sgr0)             # Reset
info=${bldwht}*${txtrst}        # Feedback
pass=${bldblu}*${txtrst}
warn=${bldred}*${txtrst}
ques=${bldblu}?${txtrst}


DB="KMS"
KMS="/home/developer/workspace/HMS_KMS/"
LIFERAY_TOMCAT="/home/developer/programs/liferay-portal-6.1.0-ce-ga1"

KMS_SH=$KMS"kms.sh"
KMS_TRUNK=$KMS"trunk"
KMS_BRANCHES=$KMS"branches"
KMS_TAGS=$KMS"tags"
KMS_DB_BACKUP=$KMS_TRUNK"/configuration/DB/"
KMS_DATA_BACKUP=$KMS_TRUNK"/configuration/document_library/"
DB_BACKUP_FILE=$DB"_`date +%y.%m.%d`.backup"
DB_7ZIP_FILE=$DB"_`date +%y.%m.%d`.7z"	

LIFERAY_LOGS=$LIFERAY_TOMCAT"/logs"
LIFERAY_LOG_FILE=$LIFERAY_LOGS"/liferay.`date +%Y-%m-%d`.log"
TOMCAT_LOGS=$LIFERAY_TOMCAT"/tomcat-7.0.23/logs"
TOMCAT_LOG_FILE=$TOMCAT_LOGS"/catalina.`date +%Y-%m-%d`.log"
LIFERAY_TOMCAT_TEMP=$LIFERAY_TOMCAT"/tomcat-7.0.23/temp"
STARTUPSH=$LIFERAY_TOMCAT"/tomcat-7.0.23/bin/startup.sh"
SHUTDOWNSH=$LIFERAY_TOMCAT"/tomcat-7.0.23/bin/shutdown.sh"
AUTODEPLOY=$LIFERAY_TOMCAT"/deploy"
WEBAPPS=$LIFERAY_TOMCAT"/tomcat-7.0.23/webapps/"
DATA=$LIFERAY_TOMCAT"/data"
DATA_DL=$DATA"/document_library/"
DATA_BACKUP_FILE="document_library_backup_`date +%y.%m.%d`.tar"	
DATA_BACKUP_FILE_7Z="document_library_backup_`date +%y.%m.%d`.7z"
DATA_LOCAL_BACKUP_FILE="document_library_local_backup_`date +%y.%m.%d`.tar"
DATA_LOCAL_BACKUP_FILE_7Z="document_library_local_backup_`date +%y.%m.%d`.7z"

D1="KMSExt-ext"
F1="ext-KMSExt-ext.xml"
F2="ext-KMSExt-ext-service.jar"

CHROME="/opt/google/chrome/google-chrome"

user="developer"
QA=("$user" "192.168.241.216" "QA TEST")
TR=("$user" "192.168.241.252" "TRUNK/REGRESSION")
CI=("$user" "192.168.241.165" "JENKINS")

cd $KMS_TRUNK;

#
# Helper function to work with files which are palnned to be restored (archives, database backups, etc)
#
function KMSRestore (){
	
# find -newer KMS_03.11.13.PROD.backup -name "*.backup"
# ls -Art *.backup | tail -n 1
# ls -ltrc *.backup -m1 | tail -n 1
# ls -ABrt1 --group-directories-first | tail -n1
# ls -tu *.backup | head -n1

# Var1 no 7za on CentOS: "7za: command not found". So need to install p7zip
# Var2 7za we have, but no archiver. Error: "there is no such archive"

	ls -lst *.7z;
	FILE1="`ls -t *.7z | head -n1`"

	if [ "$1" == "db" ]; then
		7za e -y $FILE1 > /dev/null
		ls -lstu *.backup;
		FILE="`ls -t *.backup | head -n1`"

	elif [ "$1" == "dl" ]; then
		FILE=$FILE1
	fi

	if [ "$2" == "-m" ]; then 
		# MANUAL VARIANT
		echo -n "$bldred Type file to be restored from >>> $txtrst"
		read FILE
		FILE_CONFIRM="y"

	else
		# AUTO VARIANT
		echo "Using backup file $bldred'$FILE'$txtrst"
		echo -n "$txtbld Type 'y' to confirm: $txtrst"
		read FILE_CONFIRM
	
	fi

	#var 1
	# echo "thisfile.txt"|awk -F . '{print $NF}'
	#echo “thisfile.txt”|awk -F . ‘{if (NF>1) {print $NF}}’

	#var2
	#filename=$(basename $FILE)
	#ext=${filename##*.}


	if [ "$FILE_CONFIRM" == "y" -a -f "$FILE" ]; then

		filename=$(basename $FILE); 
		ext=${filename##*.}

		if [ "$1" == "db" -a $ext == "backup" ]; then
			DB_Restore
		elif [ "$1" == "dl" -a $ext == "7z" ]; then
			DL_Restore		
		else
			echo "$bldred Backup file is not provided OR with wrong extension OR does not exist$txtrst"
		fi
	else
		echo "Try again :) Maybe you typed something wrong or there is some bug in this awesome script :)"
	fi

}


#
# DATABASE RESTORE Helper function to get list of files sorted by date and clasified by specific file extension. 
# Auto mode by default. Using -m will be manual mode
#
function DB_Restore(){

	# TBD: Implement functionality of dropping all connections OR just sending message about usage

	dropdb -U postgres "$DB"
	echo "$bldred'$DB' database dropped$txtrst"

	createdb -U postgres "$DB"
	echo "'$DB' database created"

	/usr/pgsql-9.1/bin/pg_restore -U postgres -d "$DB" "$FILE"
	echo "$bldblue'$DB' database restored$txtrst"

	#echo -n "$bldred Do you want to delete extracted file (y) or leave it for future use (n)? $txtrst"
	#read FILE_DELETE_CONFIRM
	#if [ "$FILE_DELETE_CONFIRM" == "y" ]; then
	#	rm "$FILE"
	#	echo "Temporary file: $FILE deleted"	
	#fi
	
}

#
# DOCUMENT LIBRARY RESTORE Helper function to get list of files sorted by date and clasified by specific file extension. 
# Auto mode by default. Using -m will be manual mode
#
function DL_Restore(){

	#0 Go to tomcat document_library folder and make some clearance
	cd $DATA

	if [ -d "$DATA_DL" ]; then
					
		#1 Backup existed files on tomcat
		if [ ! -f ./$DATA_LOCAL_BACKUP_FILE_7Z ]; then
			#tar -czvf ./$DATA_LOCAL_BACKUP_FILE ./document_library > /dev/null
			7za a ./$DATA_LOCAL_BACKUP_FILE_7Z ./document_library/ > /dev/null
			echo "Local data library files copied to backup ../$DATA_LOCAL_BACKUP_FILE"
		else 
			echo "File ../$DATA_LOCAL_BACKUP_FILE_7Z has been already created, at first time. Next archives forbidden."
		fi

		#2 rm -rf that fiels from document_library
		rm -rf $DATA_DL
		echo "$DATA_DL folder removed. Will be recreated shortly."

	else
		echo "$DATA_DL dolder has been removed. Untar/Unzip will create new one."
	fi

	#3 copy files from backup (extract from tar archive)
	#http://www.cyberciti.biz/faq/tar-extract-linux/
	#tar -xvf $KMS_DATA_BACKUP$FILE > /dev/null

	#4 restore files by extracting DATA_DL
	7za x $KMS_DATA_BACKUP$FILE > /dev/null

	echo "$DATA_DL has been successuly restored from KMS Production Backup."

}

#
# Helper function to setup Proxy
#
function SSProxy () {

	if [ "$1" == "reset" ] ; then
		export http_proxy=""
		export https_proxy=""
		export ftp_proxy=""
		echo "Console proxy settings removed."
	elif [ "$1" == "setup" ]; then	
		if [ -z  "`echo $http_proxy`" ]; then
			export http_proxy="proxy.softserveinc.com:8080"
			echo "HTTP Proxy was set manually to: $http_proxy"
		fi

		if [ -z  "`echo $https_proxy`" ]; then
			export https_proxy="proxy.softserveinc.com:8080"
			echo "HTTPS Proxy was set manually to: $https_proxy"
		fi

		if [ -z  "`echo $ftp_proxy`" ]; then
			export ftp_proxy="proxy.softserveinc.com:8080"
			echo "FTP Proxy was set manually to: $ftp_proxy"
		fi

		if [ -n "`echo $http_proxy`" -o -n "`echo $https_proxy`" -o -n  "`echo $ftp_proxy`" ]; then
			echo "Proxies are already set: HTTP: $http_proxy HTTPS: $https_proxy FTP: $ftp_proxy"
		fi
	else
		echo "Proxies are already set: HTTP: $http_proxy HTTPS: $https_proxy FTP: $ftp_proxy"
	fi


}

#
# Helper function to perform actions with remote KMS servers (QA TEST, TRUNK, JENKINS)
#
function RemoteActions(){

	remoteENV="$1";

	case $remoteENV in
		"qa")
			remote_user="${QA[0]}"
			remote_server="${QA[1]}"
			remote_descr="${QA[2]}"
		;;
		"trunk")
			remote_user="${TR[0]}"
			remote_server="${TR[1]}"
			remote_descr="${TR[2]}"
		;;
		"jenkins")
			remote_user="${CI[0]}"
			remote_server="${CI[1]}"
			remote_descr="${CI[2]}"
		;;
		*)
			remote_user=""
			remote_server=""
			remote_descr=""
		;;
	esac

	if [ "$remoteENV" -a "$remote_server" ]; then

		if [ "$2" == "-X" ];then
			action=""
			X_Enabled="$2"
		else
			action="$2"
			X_Enabled=""
		fi

		fileToCopy="$3"

		if [ "$action" ]; then
			echo "$bldred Are you sure to $action Remote Server $remote_server ???$txtrst If so press 'y'"
			read REMOTE_ACTION
			if [ "$REMOTE_ACTION" == "y" ]; then
			case $action in	
	
				"stop")
					ssh -t "$remote_server" $SHUTDOWNSH 
				;;
				"start")
					ssh -t "$remote_server" $STARTUPSH 
				;;
				"restart")
					kms vm "$remoteENV" stop;
					sleep 10;
					kms vm "$remoteENV" start;
				;;
				"copyTo")

					if [ -f "$fileToCopy" ];then
						file_src="`pwd`/"$fileToCopy;
						dest_location="$remote_user@$remote_server:~/Downloads"
						scp $file_src $dest_location/$fileToCopy
					else
						echo "$bldblu Looks like file is not valid file to be copied $txtrst"
					fi
				;;
				*)
					action=""
					echo "$bldred Please specify valid action to be executed on remote environment $txtrst";
				;;
			esac
			fi
		else
			action=""

			if [ "$X_Enabled" == "-X" ]; then
				remote_user="root"; X_TAIL="... with ability to execute X";

			else
				remote_user="$user"; X_TAIL="";
			fi

			echo "$bldred You will be connected to remote server in Softserve Network:$txtrst $remote_descr - $remote_server under user $remote_user $X_TAIL"
			ssh $X_Enabled $remote_user@$remote_server

		fi
	else
		echo "VM is not specified or is not valid"		
	fi
}


##
## MAIN INPUT POINT in this script. Switching between values in $1 script decides what to do next
##

case $1 in

	"updateMe")
		cd $KMS_TRUNK; svn up "$KMS_SH"
	;;

	"diffMe")
		cd $KMS_TRUNK; svn diff "$KMS_SH"
	;;

	"commitMe")
		cd $KMS_TRUNK;
		if [ "$2" != "" -a "$3" == ""  ]; then
			echo `svn ci "$KMS_SH" -m "$2"`
		elif [ "$3" != "" ]; then
			echo "$txtbld Please wrap your comment by quotes, and try commit again $txtrst"
		else
			echo "$txtbld Please provide text to use as commit message $txtrst"
		fi
	;;

	"go")
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
	
	"up") 
		cd $KMS_TRUNK;
		svn up
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

	"git" )
		# TBD
	;;

	"base")
		cd $KMS_TRUNK;
		cd KMSBase

		if [ "$2" == "sb" ]; then
			mvn liferay:build-service  > /dev/null
			echo "KMSBase:ServiceBuilder has been rebuilt"

		elif [ "$2" == "lang" ]; then
			mvn clean liferay:lang  > /dev/null
			echo "KMSBase language properties are rebulit"
		
		elif [ "$2" == "-lucene_reindex" ]; then
			# Var1
			# ./LuceneCommandLineReindexer.sh --path=/home/jforum218 --recreateIndex --type=date --fromDate=01/12/2007 --toDate=02/08/2008

			# Var2
			# https://php4u.zendesk.com/entries/20254616-How-to-rebuild-lucene-index-from-command-line-SSH-


			echo "KMSBase lhas been deployed. Lucene reindexed."	

		else
			mvn clean package liferay:deploy  > /dev/null

			#while : ####################### REWORK cause when tomcat stoped, and you do kms base - it HALTS AT THIS CASE - no updates in file no condition to exit ###############################################
			#do
			#	if [ -n "`tail -F --line=1 $LIFERAY_LOG_FILE | grep "KMSBase-0.1 are available for use"`"  ]; then
					echo "$bldblu KMSBase has been deployed $txtrst"; # break
			#	fi
			#done

		fi
			 
	;;

	
	"ext")
		cd $KMS_TRUNK;

		#1. Start Server or check if started

		#2. REMOVE KMSExt-ext directory
		cd "$WEBAPPS"
		if [ -d "$D1" ];
		then
			rm -rf "$D1"
			echo "$D1 removed"
		else
			echo "$D1 NOT found"
		fi
		
		sleep 10 # Waiting for Tomcat untill he properly undeploy KMSExt-ext module and after that we may delete jar file

		#3. REMOVE xml file
		cd "$WEBAPPS/ROOT/WEB-INF/"
		if [ -f "$F1" ];
		then
			rm "$F1"
			echo "$F1 removed"
		else
			echo "$F1 NOT found"
		fi

		sleep 5 # And a few sec more to wait for Tomcat

		#4 REMOVE jar file
		cd "$LIFERAY_TOMCAT/tomcat-7.0.23/lib/ext/"
		if [ -f "$F2" ];
		then
			rm "$F2"
			echo "$F2 removed"
		else
			echo "$F2 NOT found"
		fi
		
		#5 Install KMSExt		 
		cd $KMS_TRUNK;
		cd KMSExt
		mvn clean install > /dev/null
		echo "KMSExt has been built"
		 
		#6 Deploy KmsExt-ext
		cd KMSExt-ext
		mvn liferay:deploy > /dev/null
		sleep 10
		echo "$bldblu KMSExt-Ext has been deployed $txtrst"

		#7. Tomcat Restart		
		# Files ext-KMSExt-ext.xml and ext-KMSExt-ext-service.jar APPEAR ONLY AFTER TOMCAT RESTART
		# USE ECLIPSE RESTART kms tomcat_stop and kms tomcat_start

	;;

	"layout")
		cd $KMS_TRUNK;
		cd KMSLayout
		mvn clean package liferay:deploy > /dev/null
		echo "$bldblu KMSLayout has been deployed $txtrst"
	;;

	"theme")
		cd $KMS_TRUNK;		
		cd KMSTheme
		mvn clean package liferay:deploy > /dev/null
		#while :
		#do
		#	if [ -n "`tail -F --line=1 $LIFERAY_LOG_FILE | grep "KMSTheme-0.1 is available for use"`"  ]; then
				echo "$bldblu KMSTheme has been deployed $txtrst"; #break
		#	fi
		#done
		
	;;

	"all") #postponed
		#kms ext; 
		#kmsbase; sleep 15
		#kms layout; sleep 15
		#kms theme; sleep 10
		echo "All KMS modules are build and deployed to server, now server will be restarted";
		#kms tomcat_restart
	;;

	"db") # $2: start | stop | restart | restore
	      # if $2 == "restore" and $3 == "-m" - you want manually select file to restore
	
		cd $KMS_DB_BACKUP 

		if [ "$2" == "restore" ]; then
			if [ -n "`lsof -w -i tcp:8080 | grep java`" ]; then
				echo "Your Tomcat is still runing. Shut it down."
			else
				cd $KMS_DB_BACKUP
				KMSRestore "db" "$3";
			fi
		
		elif [ "$2" == "backup" ]; then
			echo "$DB database dump creation in progress ..."
			/usr/pgsql-9.1/bin/pg_dump -U kms -Ft KMS -f "$DB_BACKUP_FILE"
			echo "$DB database dump stored into file: $KMS_DB_BACKUP$DB_BACKUP_FILE"

			7za a -y "$KMS_DB_BACKUP$DB_7ZIP_FILE" $KMS_DB_BACKUP$DB_BACKUP_FILE

		else
			# (start, stop, restart)	
			sudo service postgresql-9.1 "$2"
		fi
	;;


	"tomcat" ) # $2 = tmp_del | start | stop | restart | data_backup | data_restore
		
		if [ "$2" == "tmp_del" ]; then
			cd $LIFERAY_TOMCAT_TEMP
			rm -rf ./*	
			echo "$txtbld Temp files from Tomcat server deleted $txtrst"
		
		elif [ "$2" == "start" ]; then
			kms tomcat tmp_del;
			$STARTUPSH > /dev/null
			sleep 45
			echo "$bldred Tomcat server started $txtrst"

		elif [ "$2" == "stop" ]; then
			$SHUTDOWNSH > /dev/null
			kms tomcat tmp_del;
			sleep 5
			echo "$bldred Tomcat server stoped $txtrst"

		elif [ "$2" == "restart" ]; then
			kms tomcat stop;	
			kms tomcat start; 
			echo "$bldred Tomcat server restarted $txtrst"

		elif [ "$2" == "data_backup" ]; then
			cd $DATA
			#tar -czvf "$KMS_DB_BACKUP/$DATA_BACKUP_FILE" "./"  > /dev/null 2>&1
			#echo "Server data files (document_library folder) backup done. File: $KMS_DB_BACKUP$DATA_BACKUP_FILE"

		elif [ "$2" == "restore" ]; then
			cd $KMS_DATA_BACKUP
			KMSRestore "dl" "$3";
		else 
			echo "You've provided 'kms tomcat' only. Please add options."	
		fi
		

	;;

# NEED IMPROVEMENTS
	"log")
		# This uses $? - a Shell variable which stores the return/exit code of the last command that was exected. 
		# grep exits with return code "0" on success and non-zero on failure (e.g. no lines found returns "1" ) - a typical arrangement for a Unix command, by the way.

		cd $LIFERAY_TOMCAT
		if [ "$2" ==  "-liferay" ]; then
			tail -f $LIFERAY_LOG_FILE
		elif [ "$2" ==  "-tomcat" ]; then  
			tail -f $TOMCAT_LOG_FILE
		else
			tail -F --lines=100 $LIFERAY_LOG_FILE $TOMCAT_LOG_FILE
		fi
		 
		#while [a = tail -f ./logs/liferay*.log]
		#do

		#	if [ grep -q $a "null" ]
		#	then
		#		break
		#	fi

		#done

	;;

	
# NEED MORE TESTING
	"node") #$2 install | uninstall | TBD 
		#$3 with_proxy = to use proxy in console to proceed with yum instalation
		

		# INFO:
		# http://stackoverflow.com/questions/5123533/how-can-i-uninstall-or-upgrade-my-old-node-js-version


		if [ -n "`npm -v`" ] 
		then
			echo "Node.JS is already installed. Version: `node -v`"; 	
			echo "NPM version: `npm -v`"; 	
			echo "For more detail hit 'npm -l'"
			exit;
		fi

		if [ "$3" == "-proxy" ]
			then
			echo "To be sure that Installation will go properly, let's check Proxy:"

			SSProxy
		fi

		if [ -n "$2" -a "$2" == "uninstall" ];then
			# Check: 
			# /bin/node bin/node-waf include/node lib/node lib/pkgconfig/nodejs.pc share/man/man1/node.1

			# rm -r bin/node bin/node-waf include/node lib/node lib/pkgconfig/nodejs.pc share/man/man1/node.1

			# which node - > file
			# /usr/local/bin/node

			# [developer@localhost trunk]$ cd /usr/local/bin/
			# [developer@localhost bin]$ ls -la
			# total 9468
			# drwxr-xr-x.  2 root root    4096 Mar 15 05:32 .
			# drwxr-xr-x. 14 root root    4096 Aug 18  2012 ..
			# lrwxrwxrwx.  1 root root      39 Mar 15 05:32 grunt -> ../lib/node_modules/grunt-cli/bin/grunt
			# -rwxr-xr-x.  1 root root 9682722 Mar 15 05:26 node
			# lrwxrwxrwx.  1 root root      38 Mar 15 05:31 npm -> ../lib/node_modules/npm/bin/npm-cli.js

			su #need root permission 

			# Execute From Sources
			#make uninstall
			# ===================

			# With no sources
			npm rm npm -g
			
			# alias
			# npm uninstall npm

			# ===================

			yum uninstall gcc-c++
			yum uninstall openssl-devel

			exit #exit from root

		fi
		
		if [ -n "$2" -a "$2" == "install" ]; then
			
			cd /home/developer/Downloads; ls -la

			echo -n "Type path to downloaded Node.JS folder >>> "
			read NODE_JS_PATH
		
			if [ -n "NODE_JS_PATH" ]
			then
				cd "$NODE_JS_PATH"; pwd
				echo -n "Now Node.JS is going to be installed. You need to be in sudoers list to proceed."

				# Need root permission to install
				su

				# =======================
				yum install openssl-devel
				yum install gcc-c++
				./configure # checks for dependencies and creates a makefile
				make # executes that makefile, which results in compiling the source code into binary executable(s), libraries and any other outputs
				make install # copies the files you just created from the current directory to their permanent homes, /usr/local/bin and such

				npm install -g grunt-cli

				kms grunt build # After Node.JS installed, we need to build Grunt.JS
				# =======================	

				exit #exit from root

			fi	
		fi

		
	;;

# NEED MORE TESTING	
	"grunt") # $2 = build | uninstall | TBD
		cd $KMS_TRUNK
		if [ -n "$2" -a "$2" == "build" ]
			then
			grunt "$2"
		elif [ -n "$2" -a "$2" == "uninstall" ]
			then
			npm uninstall -g grunt-cli
		else
			grunt
		fi
	;;

 
	"redmine") # $2: start | stop | restart
		sudo /opt/redmine-2.1.0-0/ctlscript.sh "$2"
		echo -e "$bldred Redmine action '$2' is done $txtrst"
	;;
	
	"ip")
		ifconfig | grep "inet addr:192."
	;;

	"isTomcatAlive")
		lsof -w -i tcp:8080 | grep java
		# ps auxw | grep tomcat
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
		kmsRemoteEnv="$2"
		kmsAction="$3"
		kmsFile="$4"

		if [ "$kmsAction" ];then
			RemoteActions $kmsRemoteEnv $kmsAction $kmsFile
		else 
			RemoteActions $kmsRemoteEnv
		fi

	;;
	
	"vmX")
		# Extended function to execute terminal in X11 forwading mode. 
		# In this case you will be able to run X-es - any sofftware which need GUI
		# Examples: nautilus, firefox, gnome-terminal, etc.
		# Software will be executed locally but with acces to remote server file structure

		kmsRemoteEnv="$2"
		
		RemoteActions $kmsRemoteEnv "-X"
	;;


esac

	
cd $KMS_TRUNK
# I remember that because cd was not being executed from withing kms.sh I started to use kms instead of $0 and changed .bashrc.

