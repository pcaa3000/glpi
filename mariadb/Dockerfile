FROM docker.io/mariadb:10
#
RUN echo "USE mysql;" > /docker-entrypoint-initdb.d/timezones.sql &&  mysql_tzinfo_to_sql /usr/share/zoneinfo >> /docker-entrypoint-initdb.d/timezones.sql
#
#ENV MYSQL_RANDOM_ROOT_PASSWORD yes
ENV MYSQL_DATABASE glpi
ENV MYSQL_USER glpi
ENV MYSQL_PASSWORD glpi
#ENV MYSQL_ROOT_PASSWORD glpi
#
VOLUME /var/lib/mysql
#
EXPOSE 3306
#
COPY src/*.sql /docker-entrypoint-initdb.d/
COPY src/*.sh /docker-entrypoint-initdb.d/
RUN chmod 755 /docker-entrypoint-initdb.d/*.sh
