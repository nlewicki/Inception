#!/bin/bash

#erstellt Verzeichnis das fuer Unix-Socket gebraucht wird (sonst fehler meldung)
# mkdir -p /run/php

# # Umgebungsvariablen ins wp-config schreiben
# cp wp-config-sample.php wp-config.php

# # Ersetzt die Platzhalter in wp-config.php durch echte werte
# sed -i "s/database_name_here/$DB_NAME/" wp-config.php
# sed -i "s/username_here/$DB_USER/" wp-config.php
# sed -i "s/password_here/$DB_PASSWORD/" wp-config.php
# sed -i "s/localhost/$DB_HOST/" wp-config.php

# # WordPress-Dateienberechtigungen korrekt setzen
# chown -R www-data:www-data /var/www/html

# # PHP-FPM im Vordergrund starten (-F = Foreground), ohne wird container automatisch beendet
# php-fpm7.4 -F

#!/bin/bash

mkdir -p /run/php

# Wenn index.php nicht existiert, lade WordPress herunter
if [ ! -f /var/www/html/index.php ]; then
  echo "📥 Lade WordPress herunter..."
  curl -o /tmp/wordpress.tar.gz https://wordpress.org/latest.tar.gz
  tar -xzf /tmp/wordpress.tar.gz -C /var/www/html --strip-components=1
  rm /tmp/wordpress.tar.gz
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

chown -R www-data:www-data /var/www/html

# Warte auf Datenbankverbindung
until mysqladmin ping -h"$DB_HOST" --silent; do
  echo "⏳ Warte auf Datenbank $DB_HOST..."
  sleep 1
done

echo "🚀 Starte PHP-FPM..."
php-fpm7.4 -F
