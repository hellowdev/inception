FROM debian:bookworm

RUN apt-get update && apt-get install -y nginx openssl


RUN mkdir -p /etc/nginx/ssl

RUN openssl req -x509 -nodes \
-keyout /etc/nginx/ssl/nginx.key \
-out /etc/nginx/ssl/nginx.crt \
-subj "/C=MA/ST=Casablanca/L=Casablanca/O=42/CN=$DOMAIN_NAME"


COPY conf/nginx.conf /etc/nginx/conf.d/nginx.conf


ENTRYPOINT ["nginx", "-g", "daemon off;"]
