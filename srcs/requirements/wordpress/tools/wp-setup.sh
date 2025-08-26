#!/bin/bash

set -euo pipefail

# Ordner für PHP-FPM-Socket o.ä.
mkdir -p /run/php

# Wenn index.php nicht existiert, lade WordPress herunter
if [ ! -f /var/www/html/index.php ]; then
  echo "📥 Lade WordPress herunter..."
  apt-get update >/dev/null 2>&1 || true
  command -v curl >/dev/null || apt-get install -y curl >/dev/null 2>&1
  curl -fsSL -o /tmp/wordpress.tar.gz https://wordpress.org/latest.tar.gz
  tar -xzf /tmp/wordpress.tar.gz -C /var/www/html --strip-components=1
  rm -f /tmp/wordpress.tar.gz
fi

# Nur wenn wp-config nicht existiert → konfigurieren
if [ ! -f /var/www/html/wp-config.php ]; then
  echo "⚙️ Konfiguriere wp-config.php"
  cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
  sed -i "s/database_name_here/$DB_NAME/" /var/www/html/wp-config.php
  sed -i "s/username_here/$DB_USER/" /var/www/html/wp-config.php
  sed -i "s/password_here/$DB_PASSWORD/" /var/www/html/wp-config.php
  sed -i "s/localhost/$DB_HOST/" /var/www/html/wp-config.php
fi

# Eigentümer setzen (für Uploads/Plugins)
chown -R www-data:www-data /var/www/html

# Warte auf Datenbankverbindung
until mysqladmin ping -h"$DB_HOST" --silent; do
  echo "⏳ Warte auf Datenbank $DB_HOST..."
  sleep 1
done

echo "🚀 Starte PHP-FPM..."
exec php-fpm7.4 -F
