#!/bin/bash
set -e

# Read secrets (strip any trailing newlines just in case)
DB_ROOT_PASSWORD=$(cat /run/secrets/db_root_password | tr -d '\n')
DB_PASSWORD=$(cat /run/secrets/db_password | tr -d '\n')
DB_NAME=${MARIADB_DATABASE:-wordpress}
DB_USER=${MARIADB_USER:-wpuser}

# Fix permissions on data directory
chown -R mysql:mysql /var/lib/mysql
chmod -R 755 /var/lib/mysql

# Initialize MariaDB data directory if empty
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB data directory..."
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql
fi

# Start temporary MariaDB server
echo "Starting temporary MariaDB..."
mysqld_safe --skip-networking &
pid="$!"

# Wait until MariaDB is ready
until mysqladmin ping &>/dev/null; do
    echo "Waiting for MariaDB to start..."
    sleep 1
done

# Ensure root user, WordPress DB, and user exist
echo "Ensuring database and users exist..."
mysql -uroot -p"$DB_ROOT_PASSWORD" <<EOF
-- Set root password and grant privileges
CREATE USER IF NOT EXISTS 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';
CREATE USER IF NOT EXISTS 'root'@'%' IDENTIFIED BY '${DB_ROOT_PASSWORD}';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;

-- Create WordPress database and user
CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\`;
CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO '${DB_USER}'@'%';

FLUSH PRIVILEGES;
EOF

# Shutdown temporary MariaDB
mysqladmin -uroot -p"$DB_ROOT_PASSWORD" shutdown
wait "$pid"

# Start MariaDB in normal mode
echo "MariaDB setup complete! Starting in normal mode..."
exec mysqld_safe --user=mysql --bind-address=0.0.0.0
