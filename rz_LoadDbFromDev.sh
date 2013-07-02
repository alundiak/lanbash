#!/bin/sh
#
# Load from test
DB_HOST="192.168.2.5"
DB_NAME1="razorsocial_platform"
DB_NAME2="razorsocial_platform"
DB_USER="root"
DB_PASS="softjourn"

DB_NAME="razorsocial_platform"

  case $1 in
    $DBNAME1) 
      #DB_NAME = $DB_NAME1;
      ;;
    $DBNAME2) 
      ;;
#DB_NAME = $DB_NAME2;
    *)
      echo "You should select some db"; exit ;;
  esac

export PATH=$PATH:/usr/local/mysql/bin/
# dump schema
mysqldump -h "$DB_HOST" -u "$DB_USER" -d -R -p "$DB_NAME" -r "$DB_NAME-schema.sql" --password="$DB_PASS"

# dump data
mysqldump -h "$DB_HOST" -u "$DB_USER" -t -p "$DB_NAME" -r "$DB_NAME-data.sql" --password="$DB_PASS"

# load to localhost
DB_HOST="localhost"
DB_NAME=$DB_NAME
DB_USER="root"
#DB_PASS="MY_LOCAL_PASS"
echo -n "Please type password for your local DB server\n";

stty -echo
read DB_PASS;
stty echo



# drop "old" old database
echo "DROP DATABASE IF EXISTS "$DB_NAME"_old;" | mysql -h "$DB_HOST" -u "$DB_USER" -p mysql --password="$DB_PASS"
# create "new" old database
echo "CREATE DATABASE "$DB_NAME"_old;" | mysql -h "$DB_HOST" -u "$DB_USER" -p mysql --password="$DB_PASS"
# copy schema
mysqldump -h "$DB_HOST" -u "$DB_USER" -d -R -p "$DB_NAME" --password="$DB_PASS" | mysql -h "$DB_HOST" -u "$DB_USER" -p $DB_NAME"_old" --password="$DB_PASS"
# copy data
mysqldump -h "$DB_HOST" -u "$DB_USER" -t -p "$DB_NAME" --password="$DB_PASS" | mysql -h "$DB_HOST" -u "$DB_USER" -p $DB_NAME"_old" --password="$DB_PASS"
# drop local original
echo "DROP DATABASE IF EXISTS $DB_NAME;" | mysql -h "$DB_HOST" -u "$DB_USER" -p mysql --password="$DB_PASS"
# create local
echo "CREATE DATABASE $DB_NAME;" | mysql -h "$DB_HOST" -u "$DB_USER" -p mysql --password="$DB_PASS"
# load new schema
mysql -h "$DB_HOST" -u "$DB_USER" -p "$DB_NAME" --password="$DB_PASS" < $DB_NAME"-schema.sql"
# load new data
mysql -h "$DB_HOST" -u "$DB_USER" -p "$DB_NAME" --password="$DB_PASS" < $DB_NAME"-data.sql"
rm "$DB_NAME-schema.sql" "$DB_NAME-data.sql"

echo "Database from server 192.168.2.5 migrated to Local database server";

