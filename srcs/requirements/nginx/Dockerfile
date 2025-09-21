FROM debian:11

RUN apt-get update && apt-get install -y \
    nginx \
    openssl \
    gettext \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/nginx/ssl


COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY conf/nginx.conf /etc/nginx/nginx.conf.template

COPY conf/setup_nginx.sh /usr/local/bin/setup_nginx.sh
RUN chmod +x /usr/local/bin/setup_nginx.sh

EXPOSE 443

CMD ["/usr/local/bin/setup_nginx.sh"]
