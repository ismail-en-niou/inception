FROM debian:12 

RUN apt-get update && apt-get install -y \
    vsftpd \
    && rm -rf /var/lib/apt/lists/*

COPY ./vsftpd.conf /etc/vsftpd.conf

COPY ./script.sh /usr/local/bin/script.sh
RUN chmod +x /usr/local/bin/script.sh

EXPOSE 20 21 21100-21110

CMD ["script.sh"]