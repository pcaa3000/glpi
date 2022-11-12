FROM fametec/glpi:9.5.4-php-fpm

# RUN yum -y install cronie mariadb
RUN apk add --update apk-cron && rm -rf /var/cache/apk/*

ADD crontab /etc/crontab

ADD crond-entrypoint.sh backup.sh /

#RUN chmod 0644 /etc/crontab && 
RUN chmod 755 /crond-entrypoint.sh /backup.sh

#RUN /usr/bin/crontab /etc/crontab
RUN cat /etc/crontab > /etc/crontabs/root

CMD [ "/crond-entrypoint.sh" ]
