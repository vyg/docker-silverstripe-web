FROM php:8.2-apache
ENV DEBIAN_FRONTEND=noninteractive

ARG NODE_VERSION="20.x"

ENV PATH=./vendor/bin:/composer/vendor/bin:$PATH

# Install components
RUN apt-get update -y && apt-get install -y \
    curl \
    git-core \
    gzip \
    openssh-client \
    unzip \
    zip \
    --no-install-recommends && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

# Install default PHP Extensions
RUN docker-php-ext-install -j$(nproc) \
    bcmath \
    mysqli \
    pdo \
    pdo_mysql

# Install Intl, LDAP, GD, SOAP, Tidy, XSL, Zip PHP Extensions
RUN apt-get update -y && apt-get install -y \
    zlib1g-dev \
    libicu-dev \
    g++ \
    libldap2-dev \
    libsasl2-dev \
    libgd-dev \
    libzip-dev \
    libtidy-dev \
    libxml2-dev \
    libxslt-dev \
    --no-install-recommends && \
    apt-mark auto \
    zlib1g-dev \
    libicu-dev \
    g++ \
    libldap2-dev \
    libsasl2-dev \
    libxml2-dev \
    libxslt-dev && \
    docker-php-ext-configure intl && \
    docker-php-ext-configure ldap && \
    docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install -j$(nproc) \
    intl \
    ldap \
    gd \
    soap \
    tidy \
    xsl \
    zip && \
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false && \
    rm -rf /var/lib/apt/lists/*

# Apache + xdebug configuration
RUN { \
    echo "<VirtualHost *:80>"; \
    echo "  DocumentRoot /var/www/html"; \
    echo "  LogLevel warn"; \
    echo "  ErrorLog /var/log/apache2/error.log"; \
    echo "  CustomLog /var/log/apache2/access.log combined"; \
    echo "  ServerSignature Off"; \
    echo "  <Directory /var/www/html>"; \
    echo "    Options +FollowSymLinks"; \
    echo "    Options -ExecCGI -Includes -Indexes"; \
    echo "    AllowOverride all"; \
    echo; \
    echo "    Require all granted"; \
    echo "  </Directory>"; \
    echo "  <LocationMatch assets/>"; \
    echo "    php_flag engine off"; \
    echo "  </LocationMatch>"; \
    echo; \
    echo "  IncludeOptional sites-available/000-default.local*"; \
    echo "</VirtualHost>"; \
    } | tee /etc/apache2/sites-available/000-default.conf

RUN echo "ServerName localhost" > /etc/apache2/conf-available/fqdn.conf && \
    echo "date.timezone = Pacific/Auckland" > /usr/local/etc/php/conf.d/timezone.ini && \
    echo "log_errors = On\nerror_log = /dev/stderr" > /usr/local/etc/php/conf.d/errors.ini && \
    a2enmod rewrite expires remoteip cgid && \
    usermod -u 1000 www-data && \
    usermod -G staff www-data

# Install xdebug
RUN yes | pecl install xdebug \
    && docker-php-ext-enable xdebug \
    && echo "xdebug.mode = debug" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.start_with_request = yes" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && rm -rf /tmp/pear

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/ \
    && ln -s /usr/local/bin/composer.phar /usr/local/bin/composer

# Upgrade Composer
RUN composer self-update --2

# Install PHP_CodeSniffer
RUN composer global require "squizlabs/php_codesniffer=*"

# Install CD tools
RUN curl -LO https://deployer.org/deployer.phar \
    && mv deployer.phar /usr/local/bin/dep \
    && chmod +x /usr/local/bin/dep

# Install Node.js (LTS) and Yarn via Corepack
RUN curl -fsSL "https://deb.nodesource.com/setup_${NODE_VERSION}" | bash - \
    && apt-get update && apt-get install -y --no-install-recommends nodejs \
    # Enable Corepack (ships with modern Node) to provide Yarn without separate repo
    && npm install -g corepack && corepack enable \
    && rm -rf /var/lib/apt/lists/*

# Install rysnc
RUN apt-get update && apt-get install -y rsync

# Install sspak
RUN curl -sS https://silverstripe.github.io/sspak/install | php -- /usr/local/bin

EXPOSE 80
CMD ["apache2-foreground"]
