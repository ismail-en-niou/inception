#!/bin/bash

DB_PASSWORD=$(cat /run/secrets/db_password)
DB_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)
DB_NAME=${DB_NAME:-wordpress_db}
DB_USER=${DB_USER:-wp_user}

mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld
chmod 755 /run/mysqld

if [ ! -d "/var/lib/mysql/mysql" ]; then
  echo "Initializing MariaDB..."

  mariadbd --user=mysql --bootstrap <<EOF
FLUSH PRIVILEGES;
USE mysql;

# Set root password first
ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';

# Create application database
CREATE DATABASE IF NOT EXISTS ${DB_NAME};

# Create user and grant privileges
CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'%';
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'localhost';

FLUSH PRIVILEGES;
EOF

  echo "MariaDB initialized!"
fi

exec mariadbd --user=mysql --bind-address=0.0.0.0
