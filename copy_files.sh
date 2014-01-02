#!/bin/bash
set -e

# Set the backup location
BACKUP_DIR=${BACKUP_DIR:="/tmp/backup/"}
# Make sure that it ends with a / and only 1 /
BACKUP_DIR=${BACKUP_DIR%/}/

for DIR in $@ ; do
    mkdir -p ${BACKUP_DIR}$(dirname ${DIR})
    cp -urpl ${DIR} ${BACKUP_DIR}$(dirname ${DIR})
done
