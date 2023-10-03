# Use the official PHP image with Alpine Linux
FROM php:8.1.15-fpm-alpine3.17

# Metadata
LABEL maintainer="Stuntrocket"

# Install system dependencies
RUN apk update \
    && apk add --no-cache \
    git \
    wget zip unzip \
    tidyhtml-dev \
    zlib-dev \
    libpng-dev \
    libzip-dev \
    unzip \
    nodejs \
    npm \
    php \
    php-fpm \
    php-cli \
    vim \
    php-pdo \
    php-pdo_mysql \
    php-gd \
    icu-libs \
    icu-dev \
    curl-dev \
    php-session \
    php-mysqli \
    php-tidy \
    php-curl \
    php-xml \
    php-dom \
    php-mbstring \
    php-fileinfo \
    php-intl \
    php-bcmath \
    php-simplexml \
    php-tokenizer \
    php-zip \
    php-xmlwriter \
    php-xmlreader \
    libxml2-dev \
    oniguruma-dev \
    && docker-php-ext-install \
    tidy gd zip pdo_mysql mysqli intl curl xml dom mbstring fileinfo intl bcmath \
    && rm -rf /var/cache/apk/* \
    chown -R www-data:www-data /var/www/html \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy the docker-entrypoint.sh script into the image
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

# Make sure the script is executable
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Set the entrypoint to run the docker-entrypoint.sh script
ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["php-fpm"]