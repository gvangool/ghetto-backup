#!/bin/bash
set -e

# Set the backup location
BACKUP_DIR=${BACKUP_DIR:="/tmp/git_backup/"}

if [[ $(which mysqldump &> /dev/null) ]] ; then
    # Make MySQL backup
    BACKUP_DIR=$BACKUP_DIR ./mysql.sh
fi
if [[ $(which pg_dump &> /dev/null) ]] ; then
    # Make PostgreSQL backup
    BACKUP_DIR=$BACKUP_DIR ./postgres.sh
fi
# Make file backup
BACKUP_DIR=$BACKUP_DIR ./copy_files.sh $@

pushd ${BACKUP_DIR} > /dev/null
GIT="git"
${GIT} add -A
${GIT} commit -m "Backup of $(date)"
if [ -n "$(git remote)" ] ; then
    ${GIT} push
fi
popd > /dev/null
