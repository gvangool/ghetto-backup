Backup system
=============
This is a ghetto backup system.

Common options
--------------
You can specify the backup directory by setting the ``$BACKUP_DIR``
environment variable.

.. note:: Make sure that ``BACKUP_DIR`` ends with ``/``!

Example::

  BACKUP_DIR=/var/backups/projects/ ./mysql.sh

MySQL
-----
This will create a gzip-ed dump of each MySQL database.

Basic usage::

  MYSQL_OPTS="-u root" ./mysql.sh

Advanced usage::

  GZIP="--fast" MYSQL_OPTS="-u $USERNAME -p$PASSWORD -P $PORT -h $HOST" ./mysql.sh

Some sensible defaults are provided (you will need to run this as ``root``
though). However you can overwrite the options if needed.

Options
~~~~~~~
``MYSQL_OPTS``
  The MySQL options, these are used to connect to your MySQL instance. You can
  also set that it needs to use compression (``-C``).

  Default: ``--defaults-extra-file=/etc/mysql/debian.cnf``
``MYSQLDUMP_OPTS``
  Specific options for ``mysqldump``.

  Default: ``--single-transaction --no-autocommit --quick``
``GZIP``
  ``gzip`` uses the GZIP environment variable by default to specify default
  options. We hijack this behaviour, so you can easily specify extra
  abilities.

  Default: ``-9 --rsyncable``

Files
-----
This will copy the files into the backup directory.

.. note:: old files are not deleted.

.. note:: **IDEA** use ``rsync`` instead of ``cp -ur``

Usage::

  ./copy_files.sh ~/project/my_website/uploads

Backup to git
-------------
This ties it all together. It will create a backup of the MySQl databases copy
all the paths to the ``$BACKUP_DIR``, commit it to git and push those to the
remote repository.

Usage::

  BACKUP_DIR="~/backups/" sudo ./backup_to_git.sh ~/project/my_website/uploads ~/project/web2/media/

Usage
-----
This is a full configuration example on how you would use the backup-to-git
approach.

In the crontab of the ``root`` user (``sudo crontab -e``)::

  12 * * * * (cd /home/my_user/ghetto-backup/; BACKUP_DIR="/home/my_user/backups/" ./backup_to_git.sh /home/my_user/project/my_website/uploads /home/my_user/project/web2/media/ /home/user2/project/www/media/)

Let elaborate on this.

1. Every hour at 12 past the hour, we will run the backup.
2. Go to the location of this backup system ``cd /home/my_user/ghetto-backup/;``
3. The actual backup:

   - Create a backup to ``/home/my_user/backups/``
     (``BACKUP_DIR="/home/my_user/backups/"``).
   - Use the backup-to-git system (``./backup_to_git.sh``)
   - Backup the specified directories
     (``/home/my_user/project/my_website/uploads
     /home/my_user/project/web2/media/ /home/user2/project/www/media/``)
