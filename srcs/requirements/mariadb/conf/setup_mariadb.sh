#!/bin/sh

DB_NAME=${DB_NAME:-wordpress_db}
DB_USER=${DB_USER:-wp_user}
DB_PASSWORD=${DB_PASSWORD:-ien-niou}
DB_ROOT_PASSWORD=${DB_ROOT_PASSWORD:-ien-niou}

mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld
chmod 755 /run/mysqld

if [ ! -d "/var/lib/mysql/mysql" ]; then
  mariadbd --user=mysql --bootstrap <<EOF
FLUSH PRIVILEGES;
USE mysql;

# Create root user password
ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';

# Create database
CREATE DATABASE IF NOT EXISTS ${DB_NAME};

# Create wp_user for any host (%)
CREATE USER IF NOT EXISTS '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASSWORD}';
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'%';

# Create wp_user for localhost (socket connections)
CREATE USER IF NOT EXISTS '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASSWORD}';
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'localhost';

FLUSH PRIVILEGES;
EOF
fi

exec mariadbd --user=mysql --bind-address=0.0.0.0
