#!/bin/sh

ConfigDir () {
  dirs=""
  dirs="${dirs} /usr/share/nginx/html/glpi/config" 
  dirs="${dirs} /usr/share/nginx/html/glpi/files" 
  dirs="${dirs} /usr/share/nginx/html/glpi/files/_cache" 
  dirs="${dirs} /usr/share/nginx/html/glpi/files/_cron" 
  dirs="${dirs} /usr/share/nginx/html/glpi/files/_dumps" 
  dirs="${dirs} /usr/share/nginx/html/glpi/files/_graphs" 
  dirs="${dirs} /usr/share/nginx/html/glpi/files/_locales" 
  dirs="${dirs} /usr/share/nginx/html/glpi/files/_lock" 
  dirs="${dirs} /usr/share/nginx/html/glpi/files/_log" 
  dirs="${dirs} /usr/share/nginx/html/glpi/files/_pictures" 
  dirs="${dirs} /usr/share/nginx/html/glpi/files/_plugins" 
  dirs="${dirs} /usr/share/nginx/html/glpi/files/_rss" 
  dirs="${dirs} /usr/share/nginx/html/glpi/files/_sessions" 
  dirs="${dirs} /usr/share/nginx/html/glpi/files/_tmp" 
  dirs="${dirs} /usr/share/nginx/html/glpi/files/_uploads" 
  dirs="${dirs} /usr/share/nginx/html/glpi/files/_inventories" 
  
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
      } > /usr/share/nginx/html/glpi/config/config_db.php

}

ConfigOwner () {

  chown -R www-data:www-data /usr/share/nginx/html/glpi
  chmod g+w /usr/share/nginx/html/glpi/files
  chmod g+w /usr/share/nginx/html/glpi/plugins

}

ConfigDir
ConfigDataBase
ConfigOwner

php-fpm
