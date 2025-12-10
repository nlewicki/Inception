#!/bin/bash
set -eo pipefail

# Erwartete Umgebungsvariablen (brechen das Script ab, wenn sie fehlen)
INIT_MARK_FILE="/var/lib/mysql/.initialized"
DB_NAME=$(cat /run/secrets/db_name)
DB_USER=$(cat /run/secrets/db_user)
DB_PASSWORD=$(cat /run/secrets/db_password)


# nötigen Verzeichnisse existieren
mkdir -p /run/mysqld
mkdir -p /var/lib/mysql
chown -R mysql:mysql /run/mysqld /var/lib/mysql

# 1) Check ob Systemdatenbank initialisieren
if [ ! -d "/var/lib/mysql/mysql" ]; then
  echo "Initialisiere MariaDB-Systemdatenbank..."
  mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
fi

# 2) Start MariaDB server in background
if [ ! -f "$INIT_MARK_FILE" ]; then
  echo "Starte temporären MariaDB-Server für Setup..."
  mysqld --user=mysql --datadir=/var/lib/mysql --skip-networking &
  pid="$!"

  # Warten, bis der Server wirklich bereit ist
  echo "Warte auf MariaDB..."
  until mariadb-admin ping --silent; do
    sleep 1
  done
  echo "MariaDB läuft, führe Setup-SQL aus..."

  mariadb -u root <<EOF
CREATE DATABASE IF NOT EXISTS \`$DB_NAME\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';
GRANT ALL PRIVILEGES ON \`$DB_NAME\`.* TO '$DB_USER'@'%';
FLUSH PRIVILEGES;
EOF

  echo "Stoppe temporären Server..."
  mariadb-admin shutdown || true
  wait "$pid" || true

  touch "$INIT_MARK_FILE"
  echo "Datenbank-Setup abgeschlossen."
fi

echo "Starte MariaDB im Vordergrund..."
exec mysqld --user=mysql --datadir=/var/lib/mysql
