#!/bin/bash
set -e

DB_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)
DB_PASSWORD=$(cat /run/secrets/db_password)
DB_NAME=${DB_NAME:-wordpress}
DB_USER=${DB_USER:-wpuser}

mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld
chmod 755 /run/mysqld

if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB database..."
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql

    mysqld --user=mysql --bootstrap --skip-networking=1 <<EOF
-- Root user setup
CREATE USER IF NOT EXISTS 'root'@'%' IDENTIFIED BY '${DB_ROOT_PASSWORD}';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;

-- WordPress database and user setup
CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\`;
CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO '${DB_USER}'@'%';

FLUSH PRIVILEGES;
EOF

    echo "Database initialized!"
fi

exec mysqld --user=mysql --console --bind-address=0.0.0.0