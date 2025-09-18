#!/bin/bash
set -e

SSL_DIR=/etc/nginx/ssl
CERT_FILE=${SSL_DIR}/inception.crt
KEY_FILE=${SSL_DIR}/inception.key

# Generate self-signed SSL if missing
if [ ! -f "$CERT_FILE" ] || [ ! -f "$KEY_FILE" ]; then
    echo "Generating self-signed SSL certificate..."
    mkdir -p $SSL_DIR
    openssl req -x509 -nodes -days 365 \
        -newkey rsa:2048 \
        -keyout $KEY_FILE \
        -out $CERT_FILE \
        -subj "/C=MA/ST=Tangier/L=Tetouan/O=1337/OU=IT/CN=localhost"
fi

# Fix permissions
chown -R www-data:www-data /var/www/wordpress
chmod -R 755 /var/www/wordpress

echo "Starting Nginx..."
nginx -g "daemon off;"
