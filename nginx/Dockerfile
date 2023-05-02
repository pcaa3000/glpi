# FROM fametec/glpi:9.5.9-php-fpm as PHP
FROM fametec/glpi:10.0.5-php-fpm as PHP

FROM nginx:alpine

MAINTAINER eduardo@fametec.com.br

# ENV VERSION_GLPI 10.0.2

WORKDIR /usr/share/nginx/html

#RUN groupadd --gid 82 --system www-data \
#    && adduser -u 82 --system -g www-data www-data

RUN adduser -u 82 -H -D -S -G www-data www-data

RUN rm -f /etc/nginx/conf.d/default.conf

COPY fastcgi_params /etc/nginx/

# COPY conf.d /etc/nginx/conf.d

COPY default.d /etc/nginx/default.d

COPY nginx.conf /etc/nginx/nginx.conf

 COPY --from=PHP --chown=www-data:www-data /usr/share/nginx/html/glpi /usr/share/nginx/html/glpi

# VOLUME [ "/usr/share/nginx/html/glpi/files", "/usr/share/nginx/html/glpi/plugins" ]
    VOLUME [ "/var/glpi", "/usr/share/nginx/html/glpi/plugins" , "/usr/share/nginx/html/glpi/marketplace" ]

EXPOSE 80/tcp
