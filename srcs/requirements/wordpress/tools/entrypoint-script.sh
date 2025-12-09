#!/bin/bash
set -euo pipefail

# --- Secrets aus /run/secrets lesen (wie beim Kollegen) ---
DB_NAME=$(cat /run/secrets/db_name)
DB_USER=$(cat /run/secrets/db_user)
DB_PASSWORD=$(cat /run/secrets/db_password)

WP_ADMIN_USER=$(cat /run/secrets/wp_admin_user)
WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)
WP_ADMIN_EMAIL=$(cat /run/secrets/wp_admin_email)

WP_USER=$(cat /run/secrets/wp_user)
WP_PASSWORD=$(cat /run/secrets/wp_password)
WP_EMAIL=$(cat /run/secrets/wp_email)

# --- Pflicht-ENV-Variablen prüfen ---
: "${DB_HOST:?DB_HOST is not set}"
: "${DOMAIN_NAME:?DOMAIN_NAME is not set}"

echo "🔍 Check MariaDB availability..."
until mysqladmin ping -h "$DB_HOST" -u "$DB_USER" --password="$DB_PASSWORD" --silent; do
    echo "⏳ Warte auf MariaDB unter $DB_HOST..."
    sleep 1
done
echo "✅ MariaDB ist erreichbar."

# PHP-FPM-Run-Verzeichnis
mkdir -p /run/php/

# --- WordPress nur installieren, wenn noch nicht vorhanden ---
if [ ! -f "/var/www/html/wp-config.php" ]; then
    echo "📥 Installiere WordPress..."
    mkdir -p /var/www/html
    cd /var/www/html

    # Core herunterladen
    wp core download --allow-root

    # wp-config mit DB-Verbindung erstellen
    wp config create \
        --dbname="${DB_NAME}" \
        --dbuser="${DB_USER}" \
        --dbpass="${DB_PASSWORD}" \
        --dbhost="${DB_HOST}" \
        --allow-root

    # WordPress installieren + Admin-User anlegen
    wp core install \
        --url="https://${DOMAIN_NAME}" \
        --title="42-Inception" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASSWORD}" \
        --admin_email="${WP_ADMIN_EMAIL}" \
        --skip-email \
        --allow-root

    # Normalen User anlegen
    wp user create \
        "${WP_USER}" \
        "${WP_EMAIL}" \
        --user_pass="${WP_PASSWORD}" \
        --allow-root

    # Optional: Redis-Plugin wie beim Kollegen
    echo "📦 Installiere und aktiviere Redis-Plugin..."
    wp plugin install redis-cache --activate --allow-root

    wp config set WP_REDIS_HOST 'redis' --raw --allow-root
    wp config set WP_REDIS_PORT 6379 --raw --allow-root
    wp config set WP_CACHE true --raw --allow-root

    wp redis enable --allow-root

    # Rechte setzen
    chown -R www-data:www-data /var/www/html/
    echo "✅ WordPress-Installation abgeschlossen."
else
    echo "ℹ️ WordPress ist bereits installiert, überspringe Setup."
fi

echo "🚀 Starte PHP-FPM..."
exec php-fpm7.4 -F
