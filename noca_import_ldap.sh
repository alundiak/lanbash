#!/bin/sh

# Shell script for importing LDAP entries to LDAP server on irisp1cl.noca.com

PATH_TO_LDAP='/usr/lib64/dirsrv/slapd-irisp1cl/';
PATH_TO_LDIF='/home/alundyak/May30/way1_victor';



cd $PATH_TO_LDAP;


function NetScapeRootImport() {
  DATE="`date +%F_%s`";
  ./ldif2db -n NetscapeRoot -i $PATH_TO_LDIF/NetscapeRoot.ldif > $PATH_TO_LDIF/nr_import_$DATE.log;
}

function UserRootImport() {
  DATE="`date +%F_%s`";
  ./ldif2db -n userRoot -i $PATH_TO_LDIF/userRoot.ldif > $PATH_TO_LDIF/ur_import_$DATE.log;
}


service dirsrv stop;

case $1 in

  "nr") 
      NetScapeRootImport
      ;;

  "ur") 
      UserRootImport
      ;;

  "all") 
      NetScapeRootImport
      UserRootImport
      ;;
  *)
    echo "Please provide type of import: (nr | ur | all)"; 
    exit;
    ;;
esac

service dirsrv start;


# another ways to export/importing
#http://www.thatsjava.com/java-tech/25964/

# dn: ou="cn=Directory Manager",ou=UserPreferences, ou=noca.com, o=NetscapeRoot


# (!sn='')
# (!sn=' ')
# (!sn=null)

# dn: uid=support@noca.com,ou=Admins,cn=408,ou=Merchants,o=Payments,dc=noca,dc=com
# dn: ou=Admins,cn=37,ou=Merchants,o=Payments,dc=noca,dc=com
