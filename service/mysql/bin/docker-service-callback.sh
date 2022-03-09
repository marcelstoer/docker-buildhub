#! /bin/bash

# Service callbacks for service mysql

# check if a separate callback is handling the call
[ -f /usr/local/sbin/service-$1 ] && exec /usr/local/sbin/service-$1 "$@"

case $1 in
  backup)
    ((t = SECONDS))
    DATE=$(date "+%F")
    umask 137
    mysqldump --opt ipb > /tmp/ipb.sql
    xz /tmp/ipb.sql
    chown www-data:www-data /tmp/ipb.sql
    mv {/tmp/ipd,/backups/sql-backups/$DATE}.sql.xz
    echo "$(date -u) SQL backup completed in $((t-SECONDS))secs." \
       > /proc/1/fd/1 ;;

  flushlogs)
    mysqladmin flush-logs  ;;

  *) ;;
esac
