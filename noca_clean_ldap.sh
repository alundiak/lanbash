# Script for quick clean of previous imported entries during testing

# If $1 == "nr" - script will clean NetscapeRoot entry ("o=netscaperoot")
# If $1 == "ur" - script will clean USerRoot entry ("dc=noca,dc=com")


# TODO
USER='uid=admin, ou=Administrators, ou=TopologyManagement, o=NetscapeRoot';
PASS='paybl1nc'


case $1 in

  "nr") 

      # Recursive delete entries from "o=netscaperoot"
      ldapdelete "ou=noca.com,o=netscaperoot" -D 'uid=admin, ou=Administrators, ou=TopologyManagement, o=NetscapeRoot' -w paybl1nc -x -r
      ;;

  "ur") 

      # Single delete
      ldapdelete "cn=Directory Administrators,dc=noca,dc=com" -D 'uid=admin, ou=Administrators, ou=TopologyManagement, o=NetscapeRoot' -w paybl1nc -x
      ldapdelete "ou=People,dc=noca,dc=com" -D 'uid=admin, ou=Administrators, ou=TopologyManagement, o=NetscapeRoot' -w paybl1nc -x
      ldapdelete "ou=Special Users,dc=noca,dc=com" -D 'uid=admin, ou=Administrators, ou=TopologyManagement, o=NetscapeRoot' -w paybl1nc -x

      # REcursive delete
      ldapdelete "ou=Groups,dc=noca,dc=com" -D 'uid=admin, ou=Administrators, ou=TopologyManagement, o=NetscapeRoot' -w paybl1nc -x -r
      ldapdelete "ou=Payments,dc=noca,dc=com" -D 'uid=admin, ou=Administrators, ou=TopologyManagement, o=NetscapeRoot' -w paybl1nc -x -r
      ldapdelete "o=Payments,dc=noca,dc=com" -D 'uid=admin, ou=Administrators, ou=TopologyManagement, o=NetscapeRoot' -w paybl1nc -x -r

      ;;


  "all") 

      ldapdelete "ou=noca.com,o=netscaperoot" -D 'uid=admin, ou=Administrators, ou=TopologyManagement, o=NetscapeRoot' -w paybl1nc -x -r
  
      ldapdelete "cn=Directory Administrators,dc=noca,dc=com" -D 'uid=admin, ou=Administrators, ou=TopologyManagement, o=NetscapeRoot' -w paybl1nc -x
      ldapdelete "ou=People,dc=noca,dc=com" -D 'uid=admin, ou=Administrators, ou=TopologyManagement, o=NetscapeRoot' -w paybl1nc -x
      ldapdelete "ou=Special Users,dc=noca,dc=com" -D 'uid=admin, ou=Administrators, ou=TopologyManagement, o=NetscapeRoot' -w paybl1nc -x
      ldapdelete "ou=Groups,dc=noca,dc=com" -D 'uid=admin, ou=Administrators, ou=TopologyManagement, o=NetscapeRoot' -w paybl1nc -x -r
      ldapdelete "ou=Payments,dc=noca,dc=com" -D 'uid=admin, ou=Administrators, ou=TopologyManagement, o=NetscapeRoot' -w paybl1nc -x -r
      ldapdelete "o=Payments,dc=noca,dc=com" -D 'uid=admin, ou=Administrators, ou=TopologyManagement, o=NetscapeRoot' -w paybl1nc -x -r

      ;;

  *)
    echo "Please provide type of clean: (nr | ur | all)"; 
    exit;
    ;;
esac




