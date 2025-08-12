FROM debian:bullseye

#installieren Php (quasi vorstufe zu html)
RUN apt-get update && apt-get install -y \
    php php-fpm php-mysql curl wget unzip less mariadb-client \
    && apt-get clean

# Erstelle WordPress-Verzeichnis
RUN mkdir -p /var/www/html
# Arbeitsverzeichnis fuer folgende Befehle wird gesetzt
WORKDIR /var/www/html

# Lade WordPress herunter und entpacke es
RUN curl -O https://wordpress.org/latest.tar.gz && \
    tar -xzf latest.tar.gz --strip-components=1 && \
    rm latest.tar.gz

# Kopiere Setup-Skript ins Image
COPY tools/wp-setup.sh /tmp/wp-setup.sh
RUN chmod +x /tmp/wp-setup.sh

# Stelle sicher, dass php-fpm über Port 9000 erreichbar ist
RUN sed -i 's|listen = /run/php/php7.4-fpm.sock|listen = 9000|' /etc/php/7.4/fpm/pool.d/www.conf \
 && sed -i 's|listen.owner = www-data|;listen.owner = www-data|' /etc/php/7.4/fpm/pool.d/www.conf \
 && sed -i 's|listen.group = www-data|;listen.group = www-data|' /etc/php/7.4/fpm/pool.d/www.conf

# Führe das Skript aus beim Containerstart
CMD ["/tmp/wp-setup.sh"]