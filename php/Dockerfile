#####
# Fetch composer latest build
#####
FROM composer:latest AS composer

#####
# Fetch composer latest build
#####
FROM alpine:3.13 AS iconv_1_15

# Use 'gnu-libiconv' to fix "iconv(): Wrong charset, conversion from `us-ascii' to `UTF-8//TRANSLIT' is not allowed".
RUN apk add gnu-libiconv

#####
# Build main image
#####
FROM php:fpm-alpine

ENV MARIADB_HOST mariadb-glpi

ENV MARIADB_PORT 3306

ENV MARIADB_DATABASE glpi

ENV MARIADB_USER glpi

ENV MARIADB_PASSWORD glpi

ENV VERSION_GLPI 10.0.5


ARG SRC_GLPI=
ARG TAR_GLPI=
ARG FOLDER_GLPI=glpi/
ARG FOLDER_WEB=/usr/share/nginx/html/

RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"


RUN apk update && apk add --update openssl \
    && apk add --update --no-cache --virtual .build-deps $PHPIZE_DEPS \
 #       && pecl install apcu \
 #       && docker-php-ext-enable apcu \
 #       && pecl clear-cache \
 #       && apk del .build-dependencies 

# RUN apk add --update --no-cache krb5-dev imap-dev autoconf \
  \
  # Install exif extension.
  && docker-php-ext-install exif \
  \
  # Install GD PHP extension.
  # GD extension configuration parameters changed on PHP 7.4
  # see https://www.php.net/manual/en/image.installation.php#image.installation
  && apk add freetype-dev libjpeg-turbo-dev libpng-dev jpeg-dev \
  && docker-php-ext-configure gd --with-freetype --with-jpeg \
  && docker-php-ext-install gd \
  \
  # Install intl PHP extension.
  && apk add icu-dev \
  && docker-php-ext-install intl \
  \
  # Install ldap PHP extension.
  && apk add --virtual .ldap-build-deps openldap-dev \
  && apk add libldap \
  && docker-php-ext-install ldap \
  \
  # Install imap
  && apk add --update --no-cache krb5-dev imap-dev autoconf \
  && docker-php-ext-install  opcache \
  && docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
  && docker-php-ext-install imap \ 
  && apk del -f .ldap-build-deps \
  \
  # Install memcached PHP extension.
  && apk add libmemcached-dev \
  && pecl install memcached \
  && docker-php-ext-enable memcached \
  \
  # Install mysqli PHP extension.
  && docker-php-ext-install mysqli \
  \
  # Install pcntl PHP extension (required for composer-require-checker).
  && docker-php-ext-install pcntl \
  \
  # Install redis PHP extension.
  && pecl install redis \
  && docker-php-ext-enable redis \
  \
  # Install Zip PHP extension.
  # Zip extension configuration changed on PHP 7.4
  # see https://www.php.net/manual/en/zip.installation.php
  && apk add libzip-dev bzip2-dev \
  && docker-php-ext-install zip bz2 \
  \
  # Install APCU PHP extension.
  && pecl install apcu \
  && docker-php-ext-enable apcu \
  && pecl clear-cache \ 
  \ 
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
  # Disable sodium PHP extension (Test should validate that polyfill works).
  #&& rm /usr/local/etc/php/conf.d/docker-php-ext-sodium.ini \
  \
# Remove PHP build dependencies.
  && apk del -f .build-deps \
    \
 # Clean sources list.
  && rm -rf /var/cache/apk/*


# Copy composer binary
COPY --from=composer /usr/bin/composer /usr/bin/composer

#Fix "iconv(): Wrong charset, conversion from `us-ascii' to `UTF-8//TRANSLIT' is not allowed".
COPY --from=iconv_1_15 /usr/lib/preloadable_libiconv.so /usr/lib/preloadable_libiconv.so


# VOLUME [ "/usr/share/nginx/html/glpi/files", "/usr/share/nginx/html/glpi/plugins", "/usr/share/nginx/html/glpi/marketplace" ]
VOLUME [ "/var/glpi", "/usr/share/nginx/html/glpi/plugins", "/usr/share/nginx/html/glpi/marketplace" ]
# Define GLPI environment variables
ENV \
  GLPI_INSTALL_MODE=DOCKER \
  GLPI_CONFIG_DIR=/var/glpi/config \
  GLPI_VAR_DIR=/var/glpi/files
ENV \
  # #Fix "iconv(): Wrong charset, conversion from `us-ascii' to `UTF-8//TRANSLIT' is not allowed".
  LD_PRELOAD="/usr/lib/preloadable_libiconv.so php-fpm8 php"

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

# WORKDIR /var/glpi/

EXPOSE 9000/tcp

CMD [ "/glpi-entrypoint.sh" ]
