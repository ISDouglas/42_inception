# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: ilbonnev <ilbonnev@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/10/08 16:06:43 by ilbonnev          #+#    #+#              #
#    Updated: 2025/10/08 16:42:29 by ilbonnev         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y \
      php8.2 php8.2-fpm php8.2-mysql \
      curl wget less mariadb-client \
    && rm -rf /var/lib/apt/lists/*

RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
 && chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp

RUN sed -i 's/listen = \/run\/php\/php8.2-fpm.sock/listen = 0.0.0.0:9000/' /etc/php/8.2/fpm/pool.d/www.conf

COPY conf/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

WORKDIR /var/www/html
EXPOSE 9000

ENTRYPOINT ["/entrypoint.sh"]
CMD ["php-fpm8.2", "-F"]
