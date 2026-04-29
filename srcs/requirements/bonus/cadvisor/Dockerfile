FROM debian:bullseye

RUN apt-get update && apt-get install -y wget && rm -rf /var/lib/apt/lists/*

RUN wget -O /usr/local/bin/cadvisor \
    https://github.com/google/cadvisor/releases/download/v0.47.0/cadvisor-v0.47.0-linux-amd64

RUN chmod +x /usr/local/bin/cadvisor

CMD ["cadvisor", "-port=8080"]