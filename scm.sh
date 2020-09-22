#!/bin/bash

# !!! Execute this script being root (after "su -" run) NOT sudo !!!
# /home/dev/IdeaProjects/scm_test/scm.sh

#
# Version 1.0.2.
# @author alundiak
#

# 
# SCM project Setup script:
# UI part => g++, nodejs, gruntjs
# CI part => jenkins install, jenkins run
# 
# Tested on CentOS only
#

#
# Usage (with no aliases yet):
# ./scm.sh ui_setup
# ./scm.sh jenkins_ui_setup
# ./scm.sh prj_ui_setup
# ./scm.sh jenkins_setup
# ./scm.sh jenkins_run
# ./scm.sh
#

DOWNLOADS="/home/dev/Downloads/"
SCM_ROOT="/home/dev/IdeaProjects/scm_test"
JENKINS_JOB_ROOT="/var/lib/jenkins/jobs/scm_test1/workspace/"

function gcc (){
	yum install gcc-c++ compat-gcc-32 compat-gcc-32-c++
}

function nodejs(){
	
	case $1 in

	"install" )
		
		# SRC variant
		cd $DOWNLOADS
		wget http://nodejs.org/dist/v0.10.17/node-v0.10.17.tar.gz
		tar zxf node-v0.10.17.tar.gz
		cd node-v0.10.17
		./configure && make && sudo make install 

		# SH variant with already existed NPM
		# cd /tmp/
		# wget http://npmjs.org/install.sh | sh
		# npm install now

	;;
	"update" )
		npm cache clean -f
		npm install -g n
		n stable
	;;
	"global_modules_install")
		# NPM modules with -g will be installed globally into /usr/local/lib/node_modules/*
		npm install -g grunt-cli
		npm install -g bower
	;;
	"modules_install_for_jenikins_onlly")
		cd $JENKINS_JOB_ROOT
		# npm install	#TODO think how we define Jenkins Dependencies ONLY and install them only on Jenkins server.
		# It may be manual listed modules  (npm install module1 module2 moduleX) or use package.json and otherDependencies
	;;
	"modules_install_for_project")
		# Based on package.json in Project npm will install all modules we need
		cd $SCM_ROOT
		npm install
	;;
	"modules_update") #TODO extend
		# Based on package.json in Project npm will update all modules which marked as * (with no exact version).
		# TODO more testing
		cd $SCM_ROOT
		npm update
	;;
	esac

}

#
# Common function to perform task related to Jenkins
#
function jenkins (){
	case $1 in
	"install" )

		cd $DOWNLOADS

		wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
		rpm --import http://pkg.jenkins-ci.org/redhat/jenkins-ci.org.key
		yum install jenkins
	;;
	"configure")
		echo "Now you will be prompted to edit a few files. Please press 'Enter' to proceed with file edit."
		echo "And after finish save file and close GEDIT window, so that to proceed with main script."

		echo "Press Enter to edit file /etc/sysconfig/jenkins: Find JENKINS_AJP_PORT and set/modify to '-1'"
		read GO && gedit /etc/sysconfig/jenkins

		chown jenkins:jenkins /var/lib/jenkins/ /var/log/jenkins/

		echo "Press Enter to (Optional) edit file /etc/init.d/jenkins: In string 'for candidate ...' write path to latest oracle java"
		read GO && gedit /etc/init.d/jenkins 

		#open port 8080, add next line after similar line 
		echo "Press Enter to (Optional) edit file /etc/sysconfig/iptables: Add below line into file near similar line (no need if such exists)"
		echo "-A INPUT -m state --state NEW -m tcp -p tcp --dport 8080 -j ACCEPT"
		read GO && gedit /etc/sysconfig/iptables
		
		service iptables restart

		service jenkins start	
	;;

	"run") #@deprecated - use this way only if you need Jenkins not as service. Service should be stopped beforhand to avoid conflicts
		java -jar /usr/lib/jenkins/jenkins.war
	;;
	esac
}

#
# Base Input Point
#
case $1 in
	"ui_setup")
		gcc
		nodejs install
		nodejs global_modules_install
	;;
	"prj_ui_setup")
		$0 ui_setup 
		nodejs modules_install_for_project
		# or nodejs scm_modules_update # TODO define which flow will be better
	;;
	"jenkins_ui_setup")
		$0 ui_setup 
		nodejs modules_install_for_jenikins_onlly
	;;
	"jenkins_setup" )
		jenkins install
		jenkins configure
	;;
	"jenkins_run" )
		jenkins run
	;;
	*)
		echo "You have provided not valid data. Please usage info in header of this script."
	;;
esac

