#!/bin/bash
# Script reads .env variables and creates wp-config.php

db_pw=$(cat /run/secrets/db_password)
wp_admin_pw=$(cat /run/secrets/wp_admin_pw)
wp_user_pw=$(cat /run/secrets/wp_user_pw)
if [ ! -f /var/www/html/wp-config.php ]; then
    cp -r /var/www/html/wordpress/* /var/www/html/
    rm -rf /var/www/html/wordpress


    wp config create --allow-root --path=$WP_PATH --dbname=$MARIADB_DATABASE --dbuser=$MARIADB_USER --dbpass=$db_pw --dbhost=$DB_HOST

    chmod 755 /var/www/html && chown -R www-data:www-data /var/www/html
    #DEFINE REDIS IN WP CONFIG
    # When you install a Redis plugin in WordPress, it looks for these specific constants in your wp-config.php. It uses them to create a connection
    wp config set WP_REDIS_HOST $REDIS_HOST --allow-root --path=$WP_PATH
    wp config set WP_REDIS_PORT $REDIS_PORT --raw --allow-root --path=$WP_PATH
    wp config set WP_CACHE true --raw --allow-root --path=$WP_PATH
    ########

    wp core install --allow-root --path=$WP_PATH --url=$DOMAIN_NAME --title=$SITE_TITLE --admin_user=$WP_ADMIN --admin_password=$wp_admin_pw --admin_email=$WP_ADMIN_EMAIL --skip-email
    wp user create --allow-root --path=$WP_PATH $WP_USER $WP_USER_EMAIL --role=editor --user_pass=$wp_user_pw
    
    # Install the Redis Object Cache plugin
    wp plugin install redis-cache --activate --allow-root --path=$WP_PATH
    # Enable the object cache (this creates the wp-content/object-cache.php file)
    wp redis enable --allow-root --path=$WP_PATH

fi


exec php-fpm8.2 -F