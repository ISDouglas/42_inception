#!/bin/bash

FROM debian:bookworm-slim

RUN apt-get update -y && apt-get install -y nginx openssl curl gettext-base && rm -rf /var/lib/apt/lists/*

RUN rm -f /var/www/html/index.nginx-debian.html

RUN mkdir -p /etc/nginx/ssl
RUN openssl req -x509 -nodes -days 365 -out /etc/nginx/ssl/inception.crt -keyout /etc/nginx/ssl/inception.key \
    -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=ilbonnev.42.fr/UID=ilbonnev" 

COPY ./conf/nginx.conf /etc/nginx/nginx.conf.template

EXPOSE 443

CMD ["sh", "-c", "envsubst '${DOMAIN_NAME}' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf && nginx -g 'daemon off;'"]
