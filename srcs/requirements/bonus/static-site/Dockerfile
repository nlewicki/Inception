FROM debian:bullseye

RUN apt-get update \
 && apt-get install -y busybox \
 && rm -rf /var/lib/apt/lists/*

# Create directory and copy files
RUN mkdir -p /var/www/html
COPY ./tools /var/www/html

# Expose the port
EXPOSE 8080

CMD ["busybox", "httpd", "-f", "-p", "8080", "-h", "/var/www/html"]

# busybox httpd ist ein kleiner webserver, der statische seiten kann