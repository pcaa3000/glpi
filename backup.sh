#!/bin/bash
docker exec ${USER}_mariadb-glpi_1 sh -c 'exec mysqldump glpi -uroot -pmyStr0ngP@sSW0rd' | gzip -9 > $PWD/backups/glpi-backup-$(date +%Y-%m-%d-%H-%M).sql.gz
find $PWD/backups/ -mtime +30 -delete
