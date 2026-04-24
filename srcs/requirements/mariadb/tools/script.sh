#!/bin/bash

user_pw=$(cat /run/secrets/db_password)
root_pw=$(cat /run/secrets/db_root_password)

if [ ! -d /var/lib/mysql/$MARIADB_DATABASE ]; then
mariadb-install-db --user=mysql --datadir=/var/lib/mysql

    # Create the SQL file
    cat << EOF > /tmp/init.sql
CREATE DATABASE IF NOT EXISTS ${MARIADB_DATABASE};
CREATE USER '${MARIADB_USER}'@'%' IDENTIFIED BY '$user_pw';
GRANT ALL PRIVILEGES ON ${MARIADB_DATABASE}.* TO '${MARIADB_USER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '$root_pw';
FLUSH PRIVILEGES;
EOF
    # Start mysqld and tell it to run the SQL file
    exec mysqld_safe --init-file=/tmp/init.sql
else
    # Already configured, just start
    exec mysqld_safe
fi
