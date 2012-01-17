#!/bin/bash
set -e

# Set the backup location
BACKUP_DIR=${BACKUP_DIR:="/tmp/git_backup/"}

# Make MySQL backup
BACKUP_DIR=$BACKUP_DIR ./mysql.sh
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
