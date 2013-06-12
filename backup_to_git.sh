#!/bin/bash
set -e

# Set the backup location
BACKUP_DIR=${BACKUP_DIR:="/tmp/git_backup/"}

if [[ ! -z $(which mysqldump) ]] ; then
    # Make MySQL backup
    BACKUP_DIR=$BACKUP_DIR ./mysql.sh
fi
if [[ ! -z $(which pg_dump) ]] ; then
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
