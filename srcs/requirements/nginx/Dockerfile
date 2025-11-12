FROM debian:bookworm-slim

ARG DOMAIN_NAME

#install NGINX and OpenSSL, remove apt download cache
RUN apt-get update -y && apt-get install -y nginx openssl && \
    rm -rf /var/lib/apt/lists/*

#create SSL content and root dir of webpage
RUN mkdir -p /etc/nginx/ssl /var/www/html

#create self-signed TLS certificate (valid for 365 days)
RUN openssl req -x509 -nodes -days 365 \
    -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/inception.key \
    -out /etc/nginx/ssl/inception.crt \
    -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=${DOMAIN_NAME}"

#copy config file as the nginx default one
COPY ./conf/default.conf /etc/nginx/conf.d/default.conf

#set the permission
RUN chmod 600 /etc/nginx/ssl/inception.key && \
    chmod 644 /etc/nginx/ssl/inception.crt

#port
EXPOSE 443

#run nginx as PID 1 in foreground mode
ENTRYPOINT ["nginx", "-g", "daemon off;"]