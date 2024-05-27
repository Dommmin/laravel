# Stage 1: Build the PHP image
FROM php:8.2-fpm-alpine as base

# Set working directory
WORKDIR /usr/src

# Install necessary dependencies
RUN apk update && apk add --no-cache \
    autoconf \
    gcc \
    g++ \
    make \
    pcre-dev \
    zlib-dev \
    file \
    bash \
    linux-headers \
    git \
    curl \
    libpng-dev \
    oniguruma-dev \
    libxml2-dev \
    libzip-dev \
    icu-dev \
    libc6-compat \
    zip \
    unzip \
    supervisor \
    mysql-client \
    imagemagick-dev \
    libtool \
    nodejs \
    npm

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip intl

# Install PHP PECL extensions
RUN pecl install redis xdebug imagick swoole

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy PHP-FPM configuration
COPY ./.tools/php-fpm/php-prod.ini /usr/local/etc/php/conf.d/php.ini
COPY ./.tools/php-fpm/www.conf /usr/local/etc/php-fpm.d/www.conf

# Copy application files
COPY . .

# Install application dependencies
RUN composer install --prefer-dist --no-progress --no-suggest --optimize-autoloader

# Build assets
RUN npm install && npm run build

# Change ownership and permissions
RUN chown -R www-data:www-data /usr/src && \
    chmod -R 775 ./storage ./bootstrap/cache
