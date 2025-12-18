FROM debian:bookworm

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        nginx \
        openssl \
        gettext-base \
    && rm -rf /var/lib/apt/lists/*

COPY ./conf/default.conf.template /etc/nginx/conf.d/default.conf.template
COPY ./tools/entrypoint-script.sh /entrypoint-script.sh

RUN chmod +x /entrypoint-script.sh \
    && rm -f /etc/nginx/sites-enabled/default

EXPOSE 443

ENTRYPOINT ["/entrypoint-script.sh"]