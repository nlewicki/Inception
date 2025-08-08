#!/bin/bash

#erstellt Verzeichnis das fuer Unix-Socket gebraucht wird (sonst fehler meldung)
mkdir -p /run/php

# Umgebungsvariablen ins wp-config schreiben
cp wp-config-sample.php wp-config.php

# Ersetzt die Platzhalter in wp-config.php durch echte werte
sed -i "s/database_name_here/$DB_NAME/" wp-config.php
sed -i "s/username_here/$DB_USER/" wp-config.php
sed -i "s/password_here/$DB_PASSWORD/" wp-config.php
sed -i "s/localhost/$DB_HOST/" wp-config.php

# WordPress-Dateienberechtigungen korrekt setzen
chown -R www-data:www-data /var/www/html

# PHP-FPM im Vordergrund starten (-F = Foreground), ohne wird container automatisch beendet
php-fpm7.4 -F