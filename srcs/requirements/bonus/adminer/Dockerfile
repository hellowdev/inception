FROM debian:bookworm

RUN apt-get update && apt-get install -y php php-mysqli wget \
    && rm -rf /var/lib/apt/lists/*

RUN wget -O /adminer.php https://www.adminer.org/latest.php

CMD ["php", "-S", "0.0.0.0:8080", "-t", "/"]