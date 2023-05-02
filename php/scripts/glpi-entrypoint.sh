#!/bin/sh

ConfigDir () {
  dirs=""
  dirs="${dirs} /var/glpi/config" 
  dirs="${dirs} /var/glpi/files" 
  dirs="${dirs} /var/glpi/files/_cache" 
  dirs="${dirs} /var/glpi/files/_cron" 
  dirs="${dirs} /var/glpi/files/_dumps" 
  dirs="${dirs} /var/glpi/files/_graphs" 
  dirs="${dirs} /var/glpi/files/_locales" 
  dirs="${dirs} /var/glpi/files/_lock" 
  dirs="${dirs} /var/glpi/files/_log" 
  dirs="${dirs} /var/glpi/files/_pictures" 
  dirs="${dirs} /var/glpi/files/_plugins" 
  dirs="${dirs} /var/glpi/files/_rss" 
  dirs="${dirs} /var/glpi/files/_sessions" 
  dirs="${dirs} /var/glpi/files/_tmp" 
  dirs="${dirs} /var/glpi/files/_uploads" 
  dirs="${dirs} /var/glpi/files/_inventories" 
  
  for dir in ${dirs}
  do
      if [ ! -d ${dir} ]
      then
          mkdir ${dir}
      fi
  done
}

ConfigDataBase () {

      {
        echo "<?php"; \
        echo "class DB extends DBmysql {"; \
        echo "   public \$dbhost     = \"${MARIADB_HOST}\";"; \
        echo "   public \$dbport     = \"${MARIADB_PORT}\";"; \
        echo "   public \$dbuser     = \"${MARIADB_USER}\";"; \
        echo "   public \$dbpassword = \"${MARIADB_PASSWORD}\";"; \
        echo "   public \$dbdefault  = \"${MARIADB_DATABASE}\";"; \
        echo "}"; \
        echo ; 
      } > /var/glpi/config/config_db.php

}

ConfigOwner () {

  chown -R www-data:www-data /var/glpi
  chmod g+w /var/glpi/files
  chown -R www-data:www-data /usr/share/nginx/html/glpi
  chmod g+w /usr/share/nginx/html/glpi/plugins
  chmod g+w /usr/share/nginx/html/glpi/marketplace

}

ConfigDir
ConfigDataBase
ConfigOwner

php-fpm
