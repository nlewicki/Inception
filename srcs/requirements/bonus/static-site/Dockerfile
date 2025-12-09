FROM debian:bullseye



RUN mkdir -p /var/www/html
COPY ./tools /var/www/html

CMD ["httpd", "-p", "8080", "-v", "-f", "-h", "/var/www/html"]

#busybox is a single executable providing a collection of standard Unix tools
    #It isnt as functional as a typical Linux distribution, but enough for most usecases
#httpd is a minimal http server




komischer error