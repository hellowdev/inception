FROM debian:bookworm

RUN apt-get update && apt-get install -y curl wget tar php8.2-fpm php8.2-mysql mariadb-client \
    && mkdir -p /var/www/ && cd /var/www/ && wget https://wordpress.org/latest.tar.gz \
    && tar -xzvf latest.tar.gz && rm -rf latest.tar.gz

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

RUN chown -R www-data:www-data /var/www/wordpress

COPY conf/www.conf /etc/php/8.2/fpm/pool.d/.

# Download and install WP-CLI



COPY tools/script.sh .

RUN chmod +x script.sh

ENTRYPOINT ["./script.sh"]

# ENTRYPOINT ["php-fpm8.2", "-F"]
