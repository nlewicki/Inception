#!/bin/bash
#sagt system, dass skript mit bash ausgefuehrt werden soll

# Starte MariaDB im Hintergrund
# mysqld_safe --skip-networking & #mysql_safe startet in sicherem modus (absturzschutz etc.) --skip... deaktiviert externe verbindungen. "&" macht, dass befehl im hintergrund ausgefuehrt wird
# sleep 5 #warte 5s, damit server starten kann

# Starte MariaDB
# service mariadb start

# # Warte, bis MariaDB bereit ist
# until mariadb -u root -e "SELECT 1;" >/dev/null 2>&1; do
#   echo "⏳ Warte auf MariaDB..."
#   sleep 1
# done

# # Setup-Datenbank + User
# mysql -u root <<-EOSQL #sql block wird als root ausgefuehrt
# CREATE DATABASE IF NOT EXISTS $DB_NAME;
# CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';
# GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%';
# FLUSH PRIVILEGES;
# EOSQL

# # Stoppe temporär Server, weil wir ihn nicht im Hintergrund haben wollen
# mysqladmin shutdown

# # Starte MariaDB dauerhaft im Vordergrund
# exec mysqld_safe

#!/bin/bash

# Datenbank initialisieren, falls noch nicht vorhanden
if [ ! -d "/var/lib/mysql/$DB_NAME" ]; then
  echo "📦 Initialisiere Datenbank..."
  mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql

  # Starte MariaDB im Hintergrund
  mysqld --user=mysql --datadir=/var/lib/mysql --skip-networking &
  pid="$!"

  # Warte auf Socket
  until [ -S /run/mysqld/mysqld.sock ]; do
    echo "⏳ Warte auf MariaDB-Socket..."
    sleep 1
  done

  echo "⚙️ Erstelle Datenbank und Benutzer..."
  mariadb -u root <<EOF
CREATE DATABASE IF NOT EXISTS \`$DB_NAME\`;
CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';
GRANT ALL PRIVILEGES ON \`$DB_NAME\`.* TO '$DB_USER'@'%';
FLUSH PRIVILEGES;
EOF

  kill "$pid"
  wait "$pid"
fi

echo "🚀 Starte MariaDB..."
exec mysqld --user=mysql --datadir=/var/lib/mysql
