FROM debian:bullseye-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    mariadb-server \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld

COPY ./tools/docker-entrypoint.sh /usr/local/bin/
COPY ./conf/my.cnf /etc/mysql/my.cnf
COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/

RUN chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

EXPOSE 3306

CMD [ "mysqld" ]