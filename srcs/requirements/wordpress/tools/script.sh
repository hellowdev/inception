#!/bin/bash
# Script reads .env variables and creates wp-config.php

db_pw=$(cat /run/secrets/db_password)
if [ ! -f /var/www/html/wp-config.php ]; then
    # cp /tmp/wp-config.php /var/www/html/wp-config.php
    cp -r /var/www/html/wordpress/* /var/www/html/
    rm -rf /var/www/html/wordpress


    wp config create --allow-root --path=$WP_PATH --dbname=$MARIADB_DATABASE --dbuser=$MARIADB_USER --dbpass=$db_pw --dbhost=$DB_HOST

    #DEFINE REDIS IN WP CONFIG
    # When you install a Redis plugin in WordPress, it looks for these specific constants in your wp-config.php. It uses them to create a connection
    wp config set WP_REDIS_HOST $REDIS_HOST --allow-root --path=$WP_PATH
    wp config set WP_REDIS_PORT $REDIS_PORT --raw --allow-root --path=$WP_PATH
    wp config set WP_CACHE true --raw --allow-root --path=$WP_PATH
    ########

    wp core install --allow-root --path=$WP_PATH --url=$DOMAIN_NAME --title=$SITE_TITLE --admin_user=$WP_ADMIN --admin_password=$WP_ADMIN_PASSWORD --admin_email=$WP_ADMIN_EMAIL --skip-email
    wp user create --allow-root --path=$WP_PATH $WP_USER $WP_USER_EMAIL --role=editor --user_pass=$WP_USER_PASSWORD
    
    # Install the Redis Object Cache plugin
    wp plugin install redis-cache --activate --allow-root --path=$WP_PATH
    # Enable the object cache (this creates the wp-content/object-cache.php file)
    wp redis enable --allow-root --path=$WP_PATH

fi


exec php-fpm8.2 -F