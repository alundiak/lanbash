#
## KMS.SH Script : Helper functions
#

#
## Initial Instalation Setsp of KMS project on new instances
#
function KMS_Setup (){

	# get Liferay wget or curl
	# unpuck it
	# install and configure
	# install and configure PostgresQL http://www.xtuple.org/PostgresOnLinuxServer
	# or yum install postgresql postgresql-server
	# or http://www.cyberciti.biz/faq/howto-fedora-linux-install-postgresql-server/
	# OTHER STUFF
	echo "TODO"
	#echo "`node --version; npm --version; grunt --version;`"
}



#
# Setup Softserve Proxy
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
## General function to work with files which are palnned to be restored (archives, database backups, etc)
#

#
# KMSRestore "db"
# KMSRestore "dl"
#
function KMSRestore (){
	
# find -newer KMS_03.11.13.PROD.backup -name "*.backup"
# ls -Art *.backup | tail -n 1
# ls -ltrc *.backup -m1 | tail -n 1
# ls -ABrt1 --group-directories-first | tail -n1
# ls -tu *.backup | head -n1

# Var1 no 7za on CentOS: "7za: command not found". So need to install p7zip
# Var2 7za we have, but no archiver. Error: "there is no such archive"

	FILE_Z=""
	FILE_IN=""
	FILE=""
	FILE_CONFIRM=""

	ls -lst *.7z; # just show list of archives we have

	if [ "$2" == "-m" ]; then 
		echo -n "$bldred Type file archive to be restored from >>> $txtrst"
		read FILE_IN
		FILE_Z=$FILE_IN
	else 
		FILE_Z="`ls -t *.7z | head -n1`" # Important code to get exact ARCHIVE file as latest to be used in auro-restore
	fi
	
	if [ -n "$FILE_Z" -a -f "$FILE_Z" ]; then
		echo "Archive file $bldred'$FILE_Z'$txtrst will be using $txtbld Type 'y' to confirm: $txtrst"
		read FILE_CONFIRM
	fi

	if [ "$FILE_CONFIRM" == "y" ]; then

		#filename=$(basename $FILE); 
		#ext=${filename##*.}

		if [ "$1" == "db" ]; then

			7za e -y $FILE_Z > /dev/null
			#ls -lstu *.backup;
			FILE="`ls -t *.backup | head -n1`" # Important code to get exact database .backup file for restoring
			DB_Restore "$FILE"

		elif [ "$1" == "dl" ]; then

			FILE=$FILE_Z
			DL_Restore "$FILE"

		else
			echo "$bldred Backup file is not provided OR with wrong extension OR does not exist$txtrst"
		fi
		
	else
		echo "No actions done. Try again later :) Maybe you typed something wrong or there is some bug in this awesome script :)"
	fi

}

#
## DATABASE RESTORE Helper function to get list of files sorted by date and clasified by specific file extension. 
#

#
# kms db restore  		| Auto mode by default. 
# kms db restore -m		| Using -m will be manual mode
#
function DB_Restore(){

	FILE="$1"

	if [ -n "`kms tomcat alive`" ]; then
		echo "Your Tomcat is still runing. Shut it down."
	else
		cd $KMS_DB_BACKUP

		# TBD: Implement functionality of dropping all connections OR just sending message about usage

		dropdb -U postgres "$DB"
		echo "$bldred'$DB' database dropped$txtrst"

		createdb -U postgres "$DB"
		echo "'$DB' database created"

		/usr/pgsql-9.1/bin/pg_restore -U postgres -d "$DB" "$FILE"
		echo "$bldblue'$DB' database restored$txtrst"
	
		rm $FILE # delete temp. *backup file

		echo "@HMSTN.COM users replace ..."
		DB_Replace_HMS_Users

		#echo "Postgres Server now is going to restart."
		#kms db restart

	fi
}

#
## DOCUMENT LIBRARY RESTORE Helper function to get list of files sorted by date and clasified by specific file extension. 
#

#
# kms tomcat restore  		| Auto mode by default. 
# kms tomcat restore -m		| Using -m will be manual mode
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
## TODO
#

#function KMS_DB(){}


#
## Database update code  -to get rid of email from HMS client side. We update emails with hmstn.com.ua to avoid email sending to real Client emails.
#
function DB_Replace_HMS_Users(){
	# After deployment and commit database dump and rollout new DB dump on QA TEST and TRUNK servers (OR LOCALHOST), 
	# need to run shell script on these servers to modify emails to avoid sending notification emails from our dev/qa environments to real clients.

	if [ -n "`kms tomcat alive`" ]; then
		echo "Your Tomcat is still runing. Shut it down. And hit 'kms replace_hms_users' again."
	else
		echo "$bldred Are you sure to modify all @hmstn emails? If so, hit 'y'. $txtrst";
		read READY_TO_FIX_HMS_USERS
		if [ "$READY_TO_FIX_HMS_USERS" == "y" ]; then
			psql -U kms KMS -f "$replace_hms_users"
		else
			echo "No actions to database have been done. Don't worry and try again :)"
		fi
	fi

	# In case of tomcat is alive, afer finishing script you may go to Liferay admin section
	# and "clear database cache" under user test.
	# But I would suggest to stop tomcat run script and start tomcat back.
}

#
## Backup existed Database into dump
#
function DB_Backup (){

	echo "$DB database dump creation in progress ..."
	/usr/pgsql-9.1/bin/pg_dump -U kms -Ft KMS -f "$DB_BACKUP_FILE"
	echo "$DB database dump stored into file: $KMS_DB_BACKUP$DB_BACKUP_FILE"

	7za a -y "$KMS_DB_BACKUP$DB_7ZIP_FILE" $KMS_DB_BACKUP$DB_BACKUP_FILE

}

#
## Execute KMS Modules deployment. Jul-2013 added, but code developed early 2013.
#

#
# kms base
# kms base sb
# kms base lang
# kms theme
# kms ext
# kms layout
# kms modules: base, theme (and nothing more I would suggest, but in fact code is universal :))
# kms all # dropped, maybe later will recover
#
function KMS_Modules (){

	#having $1 as [ base | theme | ext | layout ] switch here and execute appropriate code

	case $1 in

		"base")
			cd $KMS_TRUNK;
			cd KMSBase

			if [ "$2" == "sb" ]; then
				mvn liferay:build-service  > /dev/null
				echo "KMSBase:ServiceBuilder has been rebuilt"

			elif [ "$2" == "lang" ]; then
				mvn clean liferay:lang  > /dev/null
				echo "KMSBase language properties are rebulit"
			else
				mvn clean package liferay:deploy  > /dev/null

				#while : ####################### REWORK cause when tomcat stoped, and you do kms base - it HALTS AT THIS CASE - no updates in file no condition to exit #
				#do
				#	if [ -n "`tail -F --line=1 $LIFERAY_LOG_FILE | grep "KMSBase-0.1 are available for use"`"  ]; then
						echo "$bldblu KMSBase has been deployed $txtrst"; # break
				#	fi
				#done

			fi
			
			# Now to be more confident we need to rebuild our handlebars templets from KMSBase/src/main/webapp/templates/*
			#grunt template_inline
			# it will rebuild ./KMSTheme/src/main/webapp/js/templates.js if some handlebars files were been changed. If no changes - no need to redeploy KMSTheme.
				 
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
	
		"modules:")
			# variant 1 - using args.
			#for var in "$@"

			#variant 2 - using tr and echo
			#N="bla@some.com;john@home.com"
			#arr=$(echo $IN | tr ";" "\n")
			#for x in $arr

			#variant 3 - using "," delimiter weird way :)
			MODULES_LIST="$2"; 
			delimiter=',';
			#read -ra MODULES_LIST <<< "$INPUT"
			ARR=(${MODULES_LIST//$delimiter/ })
			for i in "${ARR[@]}"; do
				kms "$i"; 
				sleep 10; # some time delay between modules redeployment. with base and theme it's enough, but ext will need more time. TODO TESTING
			done
			MODULES_LIST=""
	
		;;
	esac
}



#
# Set of actions with Liferay/KMS tomcat
#

# 
# kms tomcat stop				| stop Tomcat and delete temp files and
# kms tomcat start [-withReIndex]		| delete temp files and and start Tomcat
# kms tomcat restart [-withReIndex]		| restart Tomcat using above actions
# kms tomcat alive [ {port} ]			| Check if Tomcat is alive - get PID of Tomcat/Java process
# kms tomcat data_backup			| TODO making backup of document_library
# kms tomcat restore [-m]			| Restore document_library from 7z archive into tomcat folder
# kms tomcat log [ -liferay | -catalina ]	| watch logs (liferay or native tomcat or both)
# 
function KMS_Tomcat(){

	action=$1
	option=$2
	# thiS coDe is ideally ok, but I toght that variablE -Duser.timzone will be overriten, not concatenated
	#export JAVA_OPTS="$JAVA_OPTS -Duser.timezone=Europe/Kiev "


	case $action in
		"tmp_del")
			cd $LIFERAY_TOMCAT_TEMP
			rm -rf ./*	
			echo "$txtbld Temp files from Tomcat server deleted $txtrst"
		;;
		"start")
			if [ "$2" == "-withReIndex" ]; then
				$STARTUPSH -Dindex.on.startup=true > /dev/null
				# Var2
				# ./LuceneCommandLineReindexer.sh --path=/home/jforum218 --recreateIndex --type=date --fromDate=01/12/2007 --toDate=02/08/2008
				# Var3
				# https://php4u.zendesk.com/entries/20254616-How-to-rebuild-lucene-index-from-command-line-SSH-
			else
				$STARTUPSH > /dev/null
			fi
			sleep 45
			echo "$bldred Tomcat server started $txtrst"
		;;
		"stop")
			$SHUTDOWNSH > /dev/null
			kms tomcat tmp_del;
			sleep 5
			echo "$bldred Tomcat server stoped $txtrst"
		;;
		"restart")
			kms tomcat stop;	
			kms tomcat start "$2";  ## SET $2 due to 3 functions steps and losing var $action
			echo "$bldred Tomcat server restarted $txtrst"
		;;
		"data_backup")
			cd $DATA
			#tar -czvf "$KMS_DB_BACKUP/$DATA_BACKUP_FILE" "./"  > /dev/null 2>&1
			#echo "Server data files (document_library folder) backup done. File: $KMS_DB_BACKUP$DATA_BACKUP_FILE"
		;;
		"restore")
			cd $KMS_DATA_BACKUP
			KMSRestore "dl" "$option";
		;;
		"alive")
			if [ "$option" ];then
				PORT="$option"; #otherwsie PORT=8080 by default from kms_config.sh
			fi

			lsof -w -i tcp:"$PORT" | grep java | grep localhost
	
			# kill -9 `ps auwx | grep java | awk '{print $2}' | xargs`
			# kill -9 $(pgrep java)
			# kill -9 $(pidof java)
			# killall -9 java
			# ps auxw | grep tomcat		
		;;
		"log")
			# This uses $? - a Shell variable which stores the return/exit code of the last command that was exected. 
			# grep exits with return code "0" on success and non-zero on failure (e.g. no lines found returns "1" ) - a typical arrangement for a Unix command, by the way.

			cd $LIFERAY_TOMCAT
			if [ "$attr" ==  "-liferay" ]; then
				tail -f $LIFERAY_LOG_FILE
			elif [ "$attr" ==  "-catalina" ]; then  
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
		*)
			echo "You've provided 'kms tomcat' only. Please add options."	
		;;
	esac
	
}

#
## Perform actions with remote KMS servers (QA TEST, TRUNK, JENKINS). Jun-2013 added
#

#
# kms vm [ qa | trunk | jenkins] |Remote connection to SoftServe Virtual Machines so that have ability pto perform useful actions remotely with no VMSphere.
# kms vm qa
# kms vm qa stop		| Remote stop of QA TEST server
# kms vm qa start		| Remote start of QA TEST server
# kms vm qa restart		| Remote restart of QA TEST server
# kms vm qa log
# kms vm qa copyTo {FileSource} [ {FolderDestination which is by default is ~/Downloads on remote machine} ]
# kms vm qa db [ stop | start | restart | restore | backup ] # TODO
# kms vmX qa			| Just remote connection to remote server, but with ability to run X11 , like launching chrome, firefox, nautilus, etc.
# 	The same list of actions may be performed with TRUNK and JENKINS, but not yet approved. Need to test more.
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
		destFolder="$4"

		if [ "$action" ]; then
			
			case $action in	
				"restart")
					kms vm "$remoteENV" stop
					sleep 10;
					kms vm "$remoteENV" start
				;;
				"stop")
					echo -n "Are you sure to$bldred $action $txtrst Remote Server$bldred $remote_server $txtrst?If so press 'y'"
					read REMOTE_ACTION
					if [ "$REMOTE_ACTION" == "y" ]; then
					ssh "$remote_user"@"$remote_server" $SHUTDOWNSH 
					fi
				;;
				"start")
					ssh "$remote_user"@"$remote_server" $STARTUPSH
					kms vm "$remoteENV" log 
				;;
				"log")
					ssh "$remote_user"@"$remote_server" tail -f $TOMCAT_LOGS"/catalina.out"
					# or use remote 'qatest log' (in fact kms_env.sh)
					#ssh "$remote_user"@"$remote_server" tail -f qatest log  
				;;
				"copyTo")
					if [ -f "$fileToCopy" ];then
						file_src=$fileToCopy; # Need to reseatch about pwd/$fileToCopy. Why have I been adding this code ... ?
						if [ "$destFolder" ]; then
							dest_location="$remote_user@$remote_server:/$destFolder/"
						else
							dest_location="$remote_user@$remote_server:~/Downloads/"
						fi

						scp $file_src $dest_location
					else
						echo "$bldblu Looks like file is not valid file to be copied $txtrst"
					fi
				;;
				"db:restart")
					#" stop | start | restart | restore "
					remoteAction=$3
					#ssh -t "$remote_user"@"$remote_server"  sudo service postgresql-9.1 "$remoteAction"
					#ssh -t "$remote_user"@"$remote_server" sudo tail -f /var/log/pgqsl
					echo "TODO"
				;;
				
				*)
					action=""
					echo "$bldred Please specify valid action to be executed on remote environment $txtrst";
				;;
			esac
			
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

#
## Update or install man page for KMS.SH
#
function KMS_MAN_PAGE (){
	cd $KMS
	MANFILE="$2"
	#MANPATH="/usr/share/man" # -general folder fo whole man-s
	# Looks like may be user folder
	MANPATH="/usr/local/share/man"
	case $1 in 
		"install")
			#sudo cp $KMS/$MANFILE "$MANPATH/man8/$MANFILE.1"
			#sudo gzip "$MANPATH/man8/$MANFILE.1"
													
			sudo install -g 0 -o 0 -m 0644 $KMS/$MANFILE "$MANPATH/man8/"
			gzip "$MANPATH/man8/$MANFILE.1"
		;;
		"update")

		;;
	esac
}

#
## Main function to work with Node.JS on KMS prj.
#
function KMS_NodeJS(){
	
	if [ "$2" == "-proxy" ]; then
		echo "To be sure that Installation will go properly, let's check Proxy:"

		SSProxy
	fi

	case "$1" in
		"install")

			cd "$DOWNLOADED_NODE_JS_DIR";

			#Get Node.JS from INet repos. (KMS started with 0.10.10 and now we may update to 0.10.13)
			NODE_JS_TAR="node-latest.tar.gz"
			wget "http://nodejs.org/dist/"$NODE_JS_TAR

			#ls -la
			# Here would be great to automate pickung up the folder

			# untar
			echo "Untaring ..."
			tar zxvf node-latest.tar.gz  > /dev/null

			rm $NODE_JS_TAR
			echo "Original file $NODE_JS_TAR removed ..."

			DIR_NODE_JS="`ls -dt node-v* | head -n1`" 
			echo "Node.JS untared into $DIR_NODE_JS and will be used to install."

			# go to newlly created folder
			cd $DIR_NODE_JS

			echo  "Are you sure? If so type 'y'"
			#read I_M_READY_TO_INSTALL_NODE_JS
				
			# Here should SUDO work. TBD
			su
			# =======================
			yum install openssl-devel
			yum install gcc-c++
			./configure 			# checks for dependencies and creates a makefile
			make 				# executes that makefile, which results in compiling the source code into binary executable(s), libraries and any other outputs
			make install 			# copies the files you just created from the current directory to their permanent homes, /usr/local/bin and such
			# =======================	


		;;			
		
		"update") # http://davidwalsh.name/upgrade-nodejs

			# Here should SUDO work. TBD
			su	
			npm cache clean -f
			npm install -g n
			n stable

		;;

		"uninstall") ## http://stackoverflow.com/questions/5123533/how-can-i-uninstall-or-upgrade-my-old-node-js-version
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

			# Here should SUDO work. TBD
			su 
			#=========================================================
			# With no sources
			npm rm npm -g
			# alias
			# npm uninstall npm
			
			#sudo rm -rf /usr/local/{bin/{node,npm},lib/node_modules/npm,lib/node,share/man/*/node.*}
			
			# if you have sources	
			cd "$DOWNLOADED_NODE_JS_DIR"/"node-v0.10.13";
			 make uninstall

			#yum uninstall gcc-c++
			#yum uninstall openssl-devel
			#=========================================================

		;;
	
		*)
			echo "def"
		;;
	esac
}


#
## Work with Node.JS npm modules. Jul-08 Added.
#
function NPM_Modules(){

	cd $KMS_TRUNK

	for module in ${NPM_MODULES[@]}
	do
		echo "$bldblu KMS is doing action '$1' for Grunt $module $txtrst"
		npm "$1" "$module"
	done

	# if $1 == update or outdated => do appropriated task
	#https://npmjs.org/doc/outdated.html
	#https://npmjs.org/doc/update.html

}

#
## Main function to work with Grunt.JS on KMS prj.
#
function KMS_GruntJS(){

	# WE HAVE ISSUE WITH PROXY STILL !!!

	cd $KMS_TRUNK
	case "$1" in
		"install")
			# by default registry set to https://registry.npmjs.org/ but SoftServe proxy seems to be buggy with using it
			npm config set registry=http://registry.npmjs.org/

			npm install -g grunt-cli

			grunt build # After Node.JS installed, we need to build Grunt.JS
		;;
		
		"setup")
			NPM_Modules install "$HOW_TO_INSTALL" # --save-dev 
#or
# npm install # but this way a litle buggy. JSHint stop wporking after that.
		;;

		"clear")
			NPM_Modules uninstall
	# TODO AND TEST
	#			npm uninstall grunt
	#			npm uninstall -g grunt-cli
	# TODO AND TEST
		;;
	
		"update")
			# Check what modules new are added into package.json and npm install them
			# Somehow check kms_config.sh or Gruntfile.js or kms.json to get list of modules and install/uninstall/update/check/clear them
			npm update
			# TODO
		;;

		"upgrade")
			echo "Grunt.JS upgrade"
		;;	
		
		*)
			grunt
		;;
	esac

}

#
## SCM Actions - TODO
#
function SCM (){
	echo "TODO";
}



# sudo date -s "$DATE_STRING"
# hwclock --show
# hwclock --set --date="$DATE_STRING"

