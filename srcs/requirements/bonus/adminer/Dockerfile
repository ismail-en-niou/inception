FROM debian:11

RUN apt-get update
RUN apt-get install -y php \
                       php-mysql \
                       wget

COPY adminer.sh /tmp/adminer.sh
RUN chmod +x /tmp/adminer.sh

WORKDIR /var/www/html/

EXPOSE 8088

CMD ["sh", "/tmp/adminer.sh"]