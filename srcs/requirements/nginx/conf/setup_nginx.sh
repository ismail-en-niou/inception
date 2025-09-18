#!/bin/bash

SSL_DIR=/etc/nginx/ssl
CERT_FILE=${SSL_DIR}/inception.crt
KEY_FILE=${SSL_DIR}/inception.key

if [ ! -f "$CERT_FILE" ] || [ ! -f "$KEY_FILE" ]; then
    mkdir -p $SSL_DIR
    openssl req -x509 -nodes -days 365 \
        -newkey rsa:2048 \
        -keyout $KEY_FILE \
        -out $CERT_FILE \
        -subj "/C=MA/ST=Tangier/L=Tétouan/O=1337/OU=IT/CN=localhost"
fi

nginx -g "daemon off;"
