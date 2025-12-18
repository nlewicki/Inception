FROM debian:bookworm

# MariaDB-server installieren
RUN apt-get update \
 && apt-get install -y --no-install-recommends mariadb-server \
 && rm -rf /var/lib/apt/lists/*

# Config einspielen
COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

# Setup-Skript ins Image kopieren
COPY tools/entrypoint-script.sh /usr/local/bin/entrypoint-script.sh
RUN chmod +x /usr/local/bin/entrypoint-script.sh

# standartport for mariadb
EXPOSE 3306

# EntryPoint: launch script first
ENTRYPOINT ["/usr/local/bin/entrypoint-script.sh"]
