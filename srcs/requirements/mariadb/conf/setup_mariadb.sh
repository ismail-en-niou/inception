#!/bin/bash
set -e

DB_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)
DB_PASSWORD=$(cat /run/secrets/db_password)
DB_NAME=${MARIADB_DATABASE:-wordpress}
DB_USER=${MARIADB_USER:-wpuser}

chown -R mysql:mysql /var/lib/mysql
chmod -R 755 /var/lib/mysql

# Initialize database if empty
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB data directory..."
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql

    # Start temporary MariaDB
    mariadbd-safe --skip-networking &
    pid="$!"

    # Wait until server is ready
    until mysqladmin ping &>/dev/null; do sleep 1; done

    echo "Creating users and database..."
    mysql -uroot <<EOF
CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\`;
CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO '${DB_USER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';
CREATE USER IF NOT EXISTS 'root'@'%' IDENTIFIED BY '${DB_ROOT_PASSWORD}';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF

    # Stop temporary server
    mysqladmin -uroot -p"$DB_ROOT_PASSWORD" shutdown
    wait "$pid"
    echo "Database initialization complete!"
fi

# Start MariaDB normally
exec mariadbd-safe --user=mysql --bind-address=0.0.0.0
