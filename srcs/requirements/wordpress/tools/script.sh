#!/bin/bash
# Script reads .env variables and creates wp-config.php

db_pw=$(cat /run/secrets/db_password)
if [ ! -f /var/www/html/wp-config.php ]; then
    # cp /tmp/wp-config.php /var/www/html/wp-config.php
    cp -r /var/www/wordpress/* /var/www/html/
    rm -rf /var/www/wordpress
    wp config create --allow-root --path=/var/www/html/ --dbname=$MARIADB_DATABASE --dbuser=$MARIADB_USER --dbpass=$db_pw --dbhost=$DB_HOST
    wp core install --allow-root --path=/var/www/html/ --url=ychedmi.42.fr --title=sitetest --admin_user=supervisor --admin_password=strongpassword --admin_email=info@example.com --skip-email
fi


exec php-fpm8.2 -F