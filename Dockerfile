# Stage 1: Composer build
FROM composer:2.6 AS builder
WORKDIR /app
COPY composer.json composer.lock ./
RUN composer install --no-dev --optimize-autoloader --no-interaction --no-scripts
COPY . .

# Stage 2: Final Runtime
FROM php:8.2-fpm-alpine
WORKDIR /var/www/html

# ১. System Dependencies
RUN apk add --no-cache \
    nginx supervisor curl libpng-dev libzip-dev zip unzip \
    sqlite-dev sqlite

# ২. PHP Extensions 
RUN docker-php-ext-install pdo pdo_mysql pdo_sqlite gd zip opcache

# ৩. Copy dependencies and source code
COPY --from=builder /app/vendor ./vendor
COPY . .

# ৪. Configuration files
COPY docker/nginx.conf /etc/nginx/http.d/default.conf
COPY docker/php-fpm.conf /usr/local/etc/php-fpm.d/www.conf
COPY docker/supervisord.conf /etc/supervisord.conf

# ৫. Non-root User & Permissions Setup
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache \
    && mkdir -p /var/lib/nginx /var/tmp/nginx /var/log/nginx /var/log/supervisor /run \
    && chown -R www-data:www-data /var/lib/nginx /var/log/nginx /var/log/supervisor /run

# ৬. Entrypoint script
COPY docker/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# ৭. Security: Switch to non-root user
USER www-data

# ৮. Port and Healthcheck
EXPOSE 8080
HEALTHCHECK --interval=30s --timeout=5s \
    CMD curl -f http://localhost:8080/health || exit 1

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]