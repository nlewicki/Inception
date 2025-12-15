FROM debian:bullseye

RUN apt update \
 && apt install -y vsftpd \
 && rm -rf /var/lib/apt/lists/*

COPY ./conf/vsftpd.conf  /etc/vsftpd.conf
COPY tools/entrypoint-script.sh /entrypoint-script.sh
RUN chmod +x ./entrypoint-script.sh

ENTRYPOINT ["/entrypoint-script.sh"]

#docker exec -it ftp ls -la /var/www/html zum testen ob file wirklich auf server ist