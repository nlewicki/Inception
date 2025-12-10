FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    curl \
    tar \
    && rm -rf /var/lib/apt/lists/*

#download portainer tar
RUN curl -L https://github.com/portainer/portainer/releases/download/2.16.2/portainer-2.16.2-linux-amd64.tar.gz -o portainer.tar.gz

COPY ./tools/entrypoint-script.sh /entrypoint-script.sh
RUN chmod +x ./entrypoint-script.sh

ENTRYPOINT ["/entrypoint-script.sh"]