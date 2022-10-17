ARG PHP_VERSION

FROM php:${PHP_VERSION}-fpm

ARG NODEJS_VERSION

RUN touch /var/log/error_log

# ADD ./php/www.conf /usr/local/etc/php-fpm.d/www.conf

RUN addgroup docker && useradd -g docker -M docker
RUN mkdir -p /var/www/html
RUN chown docker:docker /var/www/html
RUN chmod 777 /var/www/html
WORKDIR /var/www/html

RUN docker-php-ext-install mysqli pdo pdo_mysql && docker-php-ext-enable pdo_mysql
# RUN pecl install -o -f xdebug-3.1.5 \
#     && docker-php-ext-enable xdebug

# RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

# RUN chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp

RUN chmod o+r /etc/resolv.conf

RUN apt-get update && apt-get install -y git
RUN apt-get update && apt-get install -y apt-utils

RUN apt-get update \
    && apt-get autoremove -y \
    && rm -r /var/lib/apt/lists/* \
    && rm -rf /tmp/*

RUN curl -sS https://getcomposer.org/installer | php -- \
--install-dir=/usr/bin --filename=composer

RUN curl -sL https://deb.nodesource.com/setup_${NODEJS_VERSION} | bash - 
RUN apt-get update && apt-get install -y nodejs
