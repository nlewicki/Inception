FROM debian:bullseye

#installiert MariaDB server 
RUN apt-get update && apt-get install -y mariadb-server && apt-get clean

#kopiert das setup-skript ins Image
COPY tools/mariadb-setup.sh /tmp/
#macht das skript ausfuehrbar
RUN chmod +x /tmp/mariadb-setup.sh

RUN mkdir -p /run/mysqld && chown mysql:mysql /run/mysqld

COPY conf/my.cnf /etc/mysql/my.cnf

#(PID 1). Skript wird aufgerufen, sobald Container startet
CMD ["/tmp/mariadb-setup.sh"]