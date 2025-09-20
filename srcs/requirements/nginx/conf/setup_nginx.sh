#!/bin/bash
set -e

SSL_DIR=/etc/nginx/ssl
CERT_FILE=${SSL_DIR}/inception.crt
KEY_FILE=${SSL_DIR}/inception.key
WEB_ROOT=/var/www/wordpress
LOG_DIR=/var/log/nginx

if [ ! -f "$CERT_FILE" ] || [ ! -f "$KEY_FILE" ]; then
    echo "Generating self-signed SSL certificate..."
    mkdir -p "$SSL_DIR"
    openssl req -x509 -nodes -days 365 \
        -newkey rsa:2048 \
        -keyout "$KEY_FILE" \
        -out "$CERT_FILE" \
        -subj "/C=MA/ST=Tangier/L=Tetouan/O=1337/OU=IT/CN=ien-niou.42.fr"
fi

mkdir -p "$WEB_ROOT"

# detect nginx runtime user from config (fallback to www-data)
NGX_USER=$(awk '/^\s*user\s+/ {print $2; exit}' /etc/nginx/nginx.conf | tr -d ';')
if [ -z "$NGX_USER" ]; then
    NGX_USER=www-data
fi

if id "$NGX_USER" >/dev/null 2>&1; then
    NGX_GROUP=$(id -gn "$NGX_USER")
    chown -R "$NGX_USER":"$NGX_GROUP" "$WEB_ROOT"
else
    chown -R www-data:www-data "$WEB_ROOT"
fi

chmod -R 755 "$WEB_ROOT"

mkdir -p "$LOG_DIR"
touch "$LOG_DIR"/access.log "$LOG_DIR"/error.log

if id "$NGX_USER" >/dev/null 2>&1; then
    NGX_GROUP=$(id -gn "$NGX_USER")
    chown -R "$NGX_USER":"$NGX_GROUP" "$LOG_DIR"
else
    chown -R www-data:www-data "$LOG_DIR"
fi

if [ -f "$WEB_ROOT/index.nginx-debian.html" ] && [ ! -f "$WEB_ROOT/index.php" ]; then
    rm -f "$WEB_ROOT/index.nginx-debian.html"
fi

echo "Starting Nginx..."
nginx -g "daemon off;"