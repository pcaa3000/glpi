FROM php:fpm-alpine

ENV MARIADB_HOST mariadb-glpi

ENV MARIADB_PORT 3306

ENV MARIADB_DATABASE glpi

ENV MARIADB_USER glpi

ENV MARIADB_PASSWORD glpi

ENV VERSION_GLPI 10.0.3


ARG SRC_GLPI=
ARG TAR_GLPI=
ARG FOLDER_GLPI=glpi/
ARG FOLDER_WEB=/usr/share/nginx/html/

RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"


RUN apk add --update --no-cache --virtual .build-dependencies $PHPIZE_DEPS \
        && pecl install apcu \
        && docker-php-ext-enable apcu \
        && pecl clear-cache \
        && apk del .build-dependencies 

RUN apk add --update --no-cache openldap-dev \
    icu-dev \
    libpng-dev \
    freetype-dev \
    jpeg-dev \
    libjpeg-turbo-dev \
    krb5-dev \
    imap-dev \
    autoconf \
    libzip-dev bzip2-dev \
  && docker-php-ext-install intl ldap gd exif mysqli opcache zip bz2 \
  && docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
  && docker-php-ext-install imap \ 
# Install XMLRPC PHP extension.
  && apk add libxml2-dev \
  && if [[ "$PHP_VERSION" =~ "^7\." ]]; then \
    # For PHP < 7.x, install bundled extension
      docker-php-ext-install xmlrpc \
  ; else \
    # For PHP 8+, install from Github (extension should be available on PECL but is not)
    mkdir -p /tmp/xmlrpc \
    && curl -LsfS https://github.com/php/pecl-networking-xmlrpc/archive/0f782ffe52cebd0a65356427b7ab72d48b72d20c/xmlrpc-0f782ff.tar.gz | tar xvz -C "/tmp/xmlrpc" --strip 1 \
    && docker-php-ext-configure /tmp/xmlrpc --with-xmlrpc \
    && docker-php-ext-install /tmp/xmlrpc \
    && rm -rf /tmp/xmlrpc \
  ; fi \
  \
# Remove PHP build dependencies.
#  && apk del -f .build-deps \
    \
 # Clean sources list.
  && rm -rf /var/cache/apk/*


VOLUME [ "/usr/share/nginx/html/glpi/files", "/usr/share/nginx/html/glpi/plugins", "/usr/share/nginx/html/glpi/marketplace" ]

WORKDIR /usr/share/nginx/html/glpi/

ADD https://github.com/glpi-project/glpi/releases/download/${VERSION_GLPI}/glpi-${VERSION_GLPI}.tgz ${FOLDER_WEB}

RUN tar -xzf ${FOLDER_WEB}glpi-${VERSION_GLPI}.tgz -C ${FOLDER_WEB} \
    && rm -Rf ${FOLDER_WEB}glpi-${VERSION_GLPI}.tgz \
    && chown -R www-data:www-data ${FOLDER_WEB}${FOLDER_GLPI}

COPY php.d/* /usr/local/etc/php/conf.d/

COPY scripts/glpi-entrypoint.sh /

RUN chmod +x /glpi-entrypoint.sh \
  && rm -rf /usr/share/nginx/html/glpi/install/install.php

RUN echo "<?php phpinfo(); ?>" >> /usr/share/nginx/html/glpi/info.php

EXPOSE 9000/tcp

CMD [ "/glpi-entrypoint.sh" ]
