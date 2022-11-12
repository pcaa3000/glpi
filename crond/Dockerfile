FROM fametec/glpi:9.5.4

RUN yum -y install cronie mariadb
 
ADD crontab /etc/crontab
#ADD crontab /var/spool/cron/root

ADD crond-entrypoint.sh backup.sh /

RUN chmod 0644 /etc/crontab && chmod 755 /crond-entrypoint.sh /backup.sh
# RUN chmod 0644 /var/spool/cron/root && chmod 755 /crond-entrypoint.sh /backup.sh

RUN mkdir /backups
VOLUME [ "/backups" ] 

CMD [ "/crond-entrypoint.sh" ]
