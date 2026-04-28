#!/bin/sh
set -e

# Cache configuration, routes, and views for production performance
echo "Caching configuration and routes..."
php artisan config:cache
php artisan route:cache
php artisan view:cache

# Ensure SQLite database exists (if using SQLite)
if [ ! -f "/var/www/html/database/database.sqlite" ]; then
    touch /var/www/html/database/database.sqlite
fi

# Start the main process manager (Supervisor)
echo "Starting Supervisor..."
exec /usr/bin/supervisord -c /etc/supervisord.conf