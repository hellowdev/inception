FROM debian:bookworm

RUN apt-get update && apt-get install -y redis && \
    rm -rf /var/lib/apt/lists/*

COPY conf/redis.conf /etc/redis/redis.conf

CMD ["redis-server", "/etc/redis/redis.conf"]
