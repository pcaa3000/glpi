#!/bin/bash
docker exec soporte_mariadb-glpi_1 sh -c 'exec mysqldump glpi -uroot -pAideVezuque8afohka1lutaeniemi6ei' | gzip -9 > /home/soporte/backups/glpi-backup-$(date +%Y-%m-%d-%H-%M).sql.gz
find /home/soporte/backups/ -mtime +30 -delete
