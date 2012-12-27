#!/bin/bash
set -e

BACKUP_DIR=${BACKUP_DIR:="/tmp/backup"}

# Make sure that the $PSQL_OPTS var is available. This is the connection
# string for PostgreSQL (e.g. PSQL_OPTS="-U $USERNAME" ./postgres.sh). By
# default this is ``-U postgres``.
PSQL_OPTS=${PSQL_OPTS:="-U postgres"}
# Set default pg_dump options
PGDUMP_OPTS=${PGDUMP_OPTS:="-Ft"}
# Set default gzip options
GZIP=${GZIP:="-9 --rsyncable"}

# Get all databases 
if [[ -z ${IGNORE_DB} ]] ; then
    DATABASE=$(psql ${PSQL_OPTS} -tc "SELECT datname FROM pg_database;" | sed -e '/^$/d' -e 's/^ *//')
else
    DATABASE=$(psql ${PSQL_OPTS} -tc "SELECT datname FROM pg_database;" | sed -e '/^$/d' -e 's/^ *//' | grep -vE "(${IGNORE_DB})")
fi

# Export databases into separate files
for DB in $DATABASES ; do
    GZIP=${GZIP} pg_dump ${PSQL_OPTS} ${PGDUMP_OPTS} ${DB} | gzip > ${BACKUP_DIR}${DB}.pgsql.gz
done
