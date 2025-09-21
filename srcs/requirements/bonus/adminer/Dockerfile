FROM debian:12

RUN apt-get update && apt-get install -y && apt install adminer \
    php \
    php-mysql \
    php-cli \
    php-curl \
    php-zip \
    php-intl \
    php-json \
    php-mbstring \
    php-xml \
    php-gd \
    php-imagick \
    php-soap \
    php-bz2 \
    php-redis \
    php-fpm \
    && rm -rf /var/lib/apt/lists/*

COPY ./adminer.conf /etc/adminer.conf

EXPOSE 8080

CMD ["php", "-S", "0.0.0.0:8080", "-t", "/usr/share/adminer"]