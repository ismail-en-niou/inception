FROM debian:11

RUN apt-get update && apt-get install -y \
    nginx \
    openssl \
    && rm -rf /var/lib/apt/lists/*

RUN groupadd -r nginx && useradd -r -g nginx nginx

RUN mkdir -p /etc/nginx/ssl

COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY conf/conf.d/default.conf /etc/nginx/conf.d/default.conf
COPY conf/setup_nginx.sh /usr/local/bin/setup_nginx.sh
RUN chmod +x /usr/local/bin/setup_nginx.sh


EXPOSE 80 443

CMD ["/usr/local/bin/setup_nginx.sh"]
