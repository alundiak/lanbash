#
## KMS.SH Script : Configuration stuff
#

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

KMS_SH="kms.sh"
KMS_FUNC_SH="kms_func.sh"
KMS_CONFIG_SH="kms_config.sh"

KMS_TRUNK=$KMS"trunk"
KMS_BRANCHES=$KMS"branches"
KMS_TAGS=$KMS"tags"
KMS_DB_BACKUP=$KMS_TRUNK"/configuration/DB/"
KMS_DATA_BACKUP=$KMS_TRUNK"/configuration/document_library/"
DB_BACKUP_FILE=$DB"_`date +%y.%m.%d`.backup"
DB_7ZIP_FILE=$DB"_`date +%y.%m.%d`.7z"	

PORT="8080"
LIFERAY_LOGS=$LIFERAY_TOMCAT"/logs"
LIFERAY_LOG_FILE=$LIFERAY_LOGS"/`cd $LIFERAY_LOGS; ls -tu | head -1 `"
TOMCAT_LOGS=$LIFERAY_TOMCAT"/tomcat-7.0.23/logs"
TOMCAT_LOG_FILE=$TOMCAT_LOGS"/`cd $TOMCAT_LOGS; ls -tu | grep catalina | head -1`"
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

REDMINE_SCRIPT="/opt/redmine-2.1.0-0/ctlscript.sh"

D1="KMSExt-ext"
F1="ext-KMSExt-ext.xml"
F2="ext-KMSExt-ext-service.jar"

CHROME="/opt/google/chrome/google-chrome"

user="developer"
QA=("$user" "192.168.241.79" "QA TEST")
TR=("$user" "192.168.241.252" "TRUNK/REGRESSION")
CI=("$user" "192.168.241.165" "JENKINS")

KMS_DATA_SQL=$KMS_TRUNK"/configuration/sql/"
replace_hms_users="$KMS_DATA_SQL/replace_hms_users.sql"

DOWNLOADED_NODE_JS_DIR="/home/developer/Downloads/"

NPM_MODULES=("grunt" "grunt-contrib-watch" "grunt-contrib-copy" "grunt-template-inline" "grunt-sync" "grunt-contrib-jshint" "grunt-contrib-csslint" "eslint-grunt" "grunt-exec" "matchdep");
# "grunt-plato" "grunt-beep" "grunt-generator" "grunt-asciify" "audio-debug" "getconfig"

