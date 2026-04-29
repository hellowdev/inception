FROM debian:bookworm

RUN apt-get update && apt-get install -y nginx && \
    rm -rf /var/lib/apt/lists/*

# # 1. Copy your Nginx configuration
COPY conf/default.conf /etc/nginx/conf.d/default.conf

# 3. Copy all your website files
COPY site/ /var/www/html/

# 4. Set permissions AFTER files are copied
RUN chmod -R 755 /var/www/html && chown -R www-data:www-data /var/www/html

CMD ["nginx", "-g", "daemon off;"]
