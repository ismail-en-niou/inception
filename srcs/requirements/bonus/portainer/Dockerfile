FROM debian:11

RUN apt-get update
RUN apt-get install -y curl \
                       tar

RUN curl -L https://github.com/portainer/portainer/releases/download/2.17.1/portainer-2.17.1-linux-amd64.tar.gz -o portainer.tar.gz
RUN tar -xvzf portainer.tar.gz -C /usr/local/bin --strip-components=1
RUN rm portainer.tar.gz

EXPOSE 9443

CMD [ "/usr/local/bin/portainer" ]