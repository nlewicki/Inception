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

# Führe das Skript aus beim Containerstart
CMD ["/tmp/wp-setup.sh"]