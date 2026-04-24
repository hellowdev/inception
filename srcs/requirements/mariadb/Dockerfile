FROM debian:bookworm

RUN apt-get update && apt-get install -y mariadb-server

COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/.

# RUN mkdir /run/mysqld/ && chown -R mysql:mysql /run/mysqld/

COPY tools/script.sh .

RUN chmod +x /script.sh


ENTRYPOINT ["./script.sh"]
# CMD ["mysqld_safe"]

