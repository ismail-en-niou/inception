FROM debian:12

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
        curl \
        mariadb-client \
        php-redis\
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
        php-redis \
        php-soap \
        php-zip

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

WORKDIR /var/www/html

RUN sed -i -e 's/listen =.*/listen = 9000/g' /etc/php/8.2/fpm/pool.d/www.conf

COPY /conf/setup.sh /

EXPOSE 9000

ENTRYPOINT ["bash", "/setup.sh"]