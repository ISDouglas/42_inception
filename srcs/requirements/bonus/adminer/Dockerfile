FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y wget php php-mysqli && rm -rf /var/lib/apt/lists/*

WORKDIR /var/www/html
RUN wget https://github.com/vrana/adminer/releases/download/v5.4.1/adminer-5.4.1.php -O index.php

EXPOSE 8080
CMD ["php", "-S", "0.0.0.0:8080", "-t", "/var/www/html"]
