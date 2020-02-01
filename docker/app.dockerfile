FROM php:7.2-fpm

RUN apt-get update && apt-get install -y \
    zlib1g-dev \
    zip \
    unzip \
    git \
    libxslt-dev \
    libmcrypt-dev \
    libwebp-dev \
    libicu-dev \
    && pecl install mcrypt-1.0.2

RUN docker-php-ext-enable mcrypt
RUN docker-php-ext-install bcmath
RUN docker-php-ext-install opcache
RUN docker-php-ext-install xsl
RUN docker-php-ext-install xmlrpc
RUN docker-php-ext-configure intl
RUN docker-php-ext-install intl
RUN docker-php-ext-install sockets
RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-install zip
RUN docker-php-ext-install mysqli

# add wget
RUN apt-get update -yqq && apt-get -f install -yyq wget

# download helper script
RUN wget -q -O /usr/local/bin/install-php-extensions https://raw.githubusercontent.com/mlocati/docker-php-extension-installer/master/install-php-extensions \
    || (echo "Failed while downloading php extension installer!"; exit 1)

# install all required extensions
RUN chmod uga+x /usr/local/bin/install-php-extensions && sync && install-php-extensions \
    gd \
    zip

COPY docker/php.ini /usr/local/etc/php/conf.d

RUN chown -R www-data:www-data /var/www
RUN usermod -u 1000 www-data

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

WORKDIR /var/www/html