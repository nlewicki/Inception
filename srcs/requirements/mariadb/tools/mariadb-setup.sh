#!/bin/bash
#sagt system, dass skript mit bash ausgefuehrt werden soll

# Starte MariaDB im Hintergrund
mysqld_safe --skip-networking & #mysql_safe startet in sicherem modus (absturzschutz etc.) --skip... deaktiviert externe verbindungen. "&" macht, dass befehl im hintergrund ausgefuehrt wird
sleep 5 #warte 5s, damit server starten kann

# Setup-Datenbank + User
mysql -u root <<-EOSQL #sql block wird als root ausgefuehrt
CREATE DATABASE IF NOT EXISTS $DB_NAME;
CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%';
FLUSH PRIVILEGES;
EOSQL

# Stoppe temporär Server, weil wir ihn nicht im Hintergrund haben wollen
mysqladmin shutdown

# Starte MariaDB dauerhaft im Vordergrund
exec mysqld_safe
