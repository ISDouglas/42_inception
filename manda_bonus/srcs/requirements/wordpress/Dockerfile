FROM debian:bookworm-slim

# install and configure php-fpm without nginx
RUN apt-get update && apt-get install -y \
      php8.2 php8.2-fpm php8.2-mysql \
      mariadb-client curl wget unzip less \
      iputils-ping \
    && rm -rf /var/lib/apt/lists/*

# download and install wp-cli
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp


# setting PHP-FPM to listen port 9000
RUN sed -i 's|listen = /run/php/php8.2-fpm.sock|listen = 0.0.0.0:9000|' \
/etc/php/8.2/fpm/pool.d/www.conf

# copy entrypoint.sh
COPY conf/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# setting the working directory
WORKDIR /var/www/html

# expose the port
EXPOSE 9000

# run entrypoint.sh when the container starts
ENTRYPOINT ["/entrypoint.sh"]

#run PHP-FPM as PID 1 in foreground mode
#CMD ["php-fpm8.2", "-F"]