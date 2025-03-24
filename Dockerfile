FROM php:8.1-apache

RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    libicu-dev \
    g++ \
    unzip \
    git \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd intl pdo pdo_mysql

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN groupadd -g 1000 www && useradd -u 1000 -g www -m www

WORKDIR /var/www/html
COPY --chown=www:www . .

USER www

RUN composer install --no-dev --optimize-autoloader --prefer-dist

EXPOSE 80

RUN a2enmod rewrite

CMD ["apache2-foreground"]
