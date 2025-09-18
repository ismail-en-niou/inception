#!/bin/bash
set -e

WORKDIR=/var/www/html
cd $WORKDIR

# Read secrets
DB_NAME=${MARIADB_DATABASE:-wordpress}
DB_USER=${MARIADB_USER:-wpuser}
DB_PASSWORD=$(cat /run/secrets/db_password)
DOMAIN_NAME=${DOMAIN_NAME:-localhost}

WP_ADMIN=${WP_ADMIN:-admin}
WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)
WP_ADMIN_EMAIL=${WP_ADMIN_EMAIL:-admin@example.com}

# Wait for MariaDB to be ready
until mysql -h mariadb -u"$DB_USER" -p"$DB_PASSWORD" -e "SELECT 1" &>/dev/null; do
  echo "Waiting for database..."
  sleep 2
done
echo "Database is ready!"

# Check if WordPress is already configured
if [ ! -f "$WORKDIR/wp-config.php" ]; then
    echo "WordPress config not found, installing..."
    
    # Download WordPress
    wp core download --locale=en_US --allow-root
    echo "WordPress downloaded."
    
    # Create wp-config.php
    wp config create --allow-root \
        --dbname="$DB_NAME" \
        --dbuser="$DB_USER" \
        --dbpass="$DB_PASSWORD" \
        --dbhost="mariadb" \
        --skip-check
    echo "wp-config.php created."
    
    # Install WordPress
    wp core install --allow-root \
        --url="$DOMAIN_NAME" \
        --title="My WordPress Site" \
        --admin_user="$WP_ADMIN" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL"
    echo "WordPress installed and admin user created."
fi

echo "WordPress setup complete."

# Ensure wp-config.php exists (in case of volume mount)
if [ ! -f wp-config.php ]; then
  echo "Creating fallback wp-config.php..."
  cat > wp-config.php <<EOL
<?php
define('DB_NAME', '${DB_NAME}');
define('DB_USER', '${DB_USER}');
define('DB_PASSWORD', '${DB_PASSWORD}');
define('DB_HOST', 'mariadb');
define('DB_CHARSET', 'utf8');
define('DB_COLLATE', '');
\$table_prefix = 'wp_';
define('WP_DEBUG', false);
if (!defined('ABSPATH')) define('ABSPATH', __DIR__ . '/');
require_once ABSPATH . 'wp-settings.php';
EOL
fi

exec php-fpm8.2 -F
