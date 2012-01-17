#!/bin/bash
set -e

# Set the backup location
BACKUP_DIR=${BACKUP_DIR:="/tmp/backup"}

for DIR in $@ ; do
    mkdir -p ${BACKUP_DIR}$(dirname ${DIR})
    cp -urp ${DIR} ${BACKUP_DIR}$(dirname ${DIR})
done
