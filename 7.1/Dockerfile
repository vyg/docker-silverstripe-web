FROM php:7.1-apache

RUN apt-get update && apt-get install -y \
    libpng12-dev \
    libtidy-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    zlib1g-dev \
    libicu-dev \
    g++ \
    wget \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) intl gd mysqli pdo pdo_mysql tidy \
    && a2enmod rewrite

RUN wget https://phar.phpunit.de/phpunit-3.7.37.phar && \
	chmod +x phpunit-3.7.37.phar && \
	mv phpunit-3.7.37.phar /usr/local/bin/phpunit

# Setup custom PHP ini
RUN echo '[Custom]\n\
date.timezone = "Pacific/Auckland"\n\
memory_limit = 1024M\n\
sendmail_path = "/usr/bin/env catchmail --smtp-ip mailcatcher"\n'\
>> /usr/local/etc/php/conf.d/custom.ini

RUN usermod -u 1000 www-data \
    && usermod -G staff www-data
