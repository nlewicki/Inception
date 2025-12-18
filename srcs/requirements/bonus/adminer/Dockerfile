FROM debian:bookworm

RUN apt update && apt install -y \
    php \
    php-mysqli \
    curl \
    && rm -rf /var/lib/apt/lists/*

    RUN mkdir -p /var/www/html

    #downloads adminer script into index.php
    RUN curl -L -o /var/www/html/index.php https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1.php
    RUN chmod 644 var/www/html/index.php

    EXPOSE 8081
    
    CMD ["php", "-S", "0.0.0.0:8081", "-t", "/var/www/html/"]

    #start buildin php webserver, accepting connections from the whole network, listens on port 8081