FROM debian:11

RUN apt-get update && apt-get install -y && apt-get install mariadb-client -y\
    php php-fpm php-mysql wget tar unzip curl vim \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /var/www/

RUN wget https://wordpress.org/latest.tar.gz && \
    tar xzvf latest.tar.gz && \
    rm latest.tar.gz

RUN sed -i 's|listen = /run/php/php7.4-fpm.sock|listen = 0.0.0.0:9000|' /etc/php/7.4/fpm/pool.d/www.conf

RUN mkdir -p /run/php

WORKDIR /var/www/wordpress
RUN cp wp-config-sample.php wp-config.php

EXPOSE 9000

CMD ["php-fpm7.4", "-F"]
