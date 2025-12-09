FROM debian:bullseye

# PHP + Tools installieren
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      php7.4-fpm \
      php7.4-mysql \
      php7.4-redis \
      php7.4-cli \
      mariadb-client \
      curl \
      less \
      unzip \
      ca-certificates \
 && update-ca-certificates \
 && rm -rf /var/lib/apt/lists/*

# wp-cli installieren
RUN curl -fsSL https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -o /usr/local/bin/wp \
 && chmod +x /usr/local/bin/wp

# PHP-FPM-Konfiguration (www.conf)
COPY conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf

# WordPress-Setup-Script
COPY tools/entrypoint-script.sh /usr/local/bin/entrypoint-script.sh
RUN chmod +x /usr/local/bin/entrypoint-script.sh

# Arbeitsverzeichnis
WORKDIR /var/www/html

# PHP-FPM hört auf Port 9000 (fastcgi_pass wordpress:9000)
EXPOSE 9000

# Script als EntryPoint (startet am Ende php-fpm7.4 -F)
ENTRYPOINT ["/usr/local/bin/entrypoint-script.sh"]
