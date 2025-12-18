#!/bin/bash
set -e

SSL_CERT_PATH="/etc/nginx/ssl"

# Generate SSL certificate if it doesn't exist
if [ ! -f "$SSL_CERT_PATH/nginx-selfsigned.crt" ]; then
    mkdir -p $SSL_CERT_PATH
    echo "Generating SSL certificate..."
    openssl req -x509 \
        -nodes \
        -days 365 \
        -newkey rsa:2048 \
        -keyout "$SSL_CERT_PATH/nginx-selfsigned.key" \
        -out "$SSL_CERT_PATH/nginx-selfsigned.crt" \
        -subj "/C=DE/ST=Baden-Wuerttemberg/L=Heilbronn/O=nlewicki/CN=${DOMAIN_NAME}" \
        2>/dev/null
    
    echo "SSL certificate generated successfully."
else
    echo "Using existing SSL certificate."
fi

# Substitute environment variables in nginx config
echo "Substituting environment variables in nginx config..."
envsubst '${DOMAIN_NAME}' < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf

# Start nginx as PID 1
echo "Starting nginx..."
exec nginx -g "daemon off;"