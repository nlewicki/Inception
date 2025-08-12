#base 
FROM debian:bullseye

#aktualisiert pakete & installiert NGINX
RUN apt-get update && apt-get install -y nginx && apt-get clean

#meine datei ueberschreibt standart datei
COPY ./conf/nginx.conf /etc/nginx/nginx.conf
#html zeug -> nicht wichtig (packt meine html datei in das Verzeichnis, das nginx ausliefert)
COPY ./html /var/www/html

COPY certs /etc/nginx/certs

#countainer verwendet port 80 
EXPOSE 443

#startet websv im vordergrund (daemon off = sagt quasi "Hauptprozess laueft noch"), sonst exited Docker
CMD ["nginx", "-g", "daemon off;"]
