#!/bin/bash
set -e

BACKUP_DIR=${BACKUP_DIR:="/tmp/backup"}

# Make sure that the $MYSQL_OPTS var is available. This is the connection
# string for mysql (e.g. MYSQL_OPTS="-u $USERNAME -p$PASSWORD -P $PORT -h
# $HOST" ./mysql.sh). By default this use the /etc/mysql/debian.cnf file.
MYSQL_OPTS=${MYSQL_OPTS:="--defaults-extra-file=/etc/mysql/debian.cnf"}
# Set default mysqldump options
MYSQLDUMP_OPTS=${MYSQLDUMP_OPTS:="--single-transaction --no-autocommit --quick"}
# Set default gzip options
GZIP=${GZIP:="-9 --rsyncable"}

# List of databases that shouldn't be backed up, separated by |
IGNORE_DB="information_schema|mysql" 

# Get all databases 
DATABASES=$(mysql ${MYSQL_OPTS} -e "SHOW DATABASES;" | sed -n 2~1p | grep -vE "(${IGNORE_DB})")

# Export databases into separate files
for DB in $DATABASES ; do
    GZIP=${GZIP} mysqldump ${MYSQL_OPTS} ${MYSQLDUMP_OPTS} ${DB} | gzip > ${BACKUP_DIR}${DB}.sql.gz
done
