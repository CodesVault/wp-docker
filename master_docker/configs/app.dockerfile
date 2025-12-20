ARG PHP_VERSION

FROM php:${PHP_VERSION}-fpm

ARG NODEJS_VERSION

RUN touch /var/log/error_log

RUN addgroup docker && useradd -rm -d /home/docker -s /bin/bash -g root -G sudo -u 1001 docker
RUN mkdir -p /var/www/html
RUN chown docker:docker /var/www/html
RUN chmod 777 /var/www/html
WORKDIR /var/www/html

RUN apt-get update && apt-get install -y libzip-dev
RUN docker-php-ext-install mysqli pdo pdo_mysql zip && docker-php-ext-enable pdo_mysql

RUN pecl install -o -f xdebug \
    && docker-php-ext-enable xdebug

# Configure xdebug
RUN echo "zend_extension=xdebug" > /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.mode=debug" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.start_with_request=yes" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.client_host=host.docker.internal" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.client_port=9003" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.log_level=0" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp

RUN apt-get update && apt-get install -y git apt-utils zip unzip

RUN apt-get update \
    && apt-get autoremove -y \
    && rm -r /var/lib/apt/lists/* \
    && rm -rf /tmp/*

RUN curl -sS https://getcomposer.org/installer | php -- \
--install-dir=/usr/bin --filename=composer

RUN curl -sL https://deb.nodesource.com/setup_${NODEJS_VERSION} | bash - 
RUN apt-get update && apt-get install -y nodejs

USER docker
