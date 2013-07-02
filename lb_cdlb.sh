#
#

#
#

"mvn clean package" - build and packaging into WAR
OR
"mvn clean install" (with packaging and pointing artifact to local maven repo)
http://maven.apache.org/guides/introduction/introduction-to-the-lifecycle.html

"mvn clean package -o" - packaging into WAR but wothout trying to download artifacts again
"mvn clean install -o" - packaging and installation to maven repo into WAR but wothout trying to download artifacts again

"mvn clean package|install -o -DskipTests=true" - packaging|installing with test skipping
"mvn clean test -o" - run only tests
More details:
http://maven.apache.org/scm/plugins/index.html


function UserConfirm() {

read CONFIRM

  case $CONFIRM in
    y|Y|YES|yes|Yes) 
      echo "Continue ...";;
    n|N|no|NO|No) 
      echo "Aborted"; exit ;;
    *)
      echo "You should confirm in proper way 'y|Y|YES|yes|Yes' OR 'n|N|no|NO|No'"; exit ;;
  esac


}


function TomcatAdminister(){

  echo "Are you sure you want to '$1' with local Glassfish server (y|n) ?"

  UserConfirm
     
  case $1 in

  gf_stop)
    $GLASSFISH/asadmin stop-domain domain1
  ;;

  gf_start)
    $GLASSFISH/asadmin start-domain domain1
  ;;

  gf_restart)
    $GLASSFISH/asadmin stop-domain domain1
    $GLASSFISH/asadmin start-domain domain1
  ;;
  
  *)
   echo "You should provide a type of action with Local Glassfish"; 
   exit
  ;;

 esac

}