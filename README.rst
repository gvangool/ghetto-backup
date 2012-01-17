Backup system
=============
This is a ghetto backup system.

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
