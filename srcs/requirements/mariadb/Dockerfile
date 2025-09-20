# Use latest Debian
FROM debian:latest

WORKDIR /mariadb

RUN apt-get update && \
    apt-get install -y mariadb-server && \
    rm -rf /var/lib/apt/lists/*

COPY conf/setup_mariadb.sh /setup_mariadb.sh
RUN chmod +x /setup_mariadb.sh

EXPOSE 3306

CMD ["/setup_mariadb.sh"]
