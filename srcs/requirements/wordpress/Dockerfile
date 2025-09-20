FROM debian:12

# Install PHP, MySQL client, and deps
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
        curl \
        mariadb-client \
        php-redis \
        php-fpm \
        php-common \
        php-mysql \
        php-xml \
        php-intl \
        php-curl \
        php-gd \
        php-imagick \
        php-cli \
        php-dev \
        php-imap \
        php-mbstring \
        php-opcache \
        php-soap \
        php-zip && \
    rm -rf /var/lib/apt/lists/*

# Install WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

# Ensure PHP-FPM listens on 9000
RUN sed -i -e 's/listen =.*/listen = 9000/g' /etc/php/8.2/fpm/pool.d/www.conf

WORKDIR /var/www/wordpress

# Copy setup script
COPY conf/setup.sh /setup.sh
RUN chmod +x /setup.sh

EXPOSE 9000

ENTRYPOINT ["/setup.sh"]
