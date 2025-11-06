# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: ilbonnev <ilbonnev@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/10/08 16:06:43 by ilbonnev          #+#    #+#              #
#    Updated: 2025/10/08 16:41:48 by ilbonnev         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

FROM debian:bookworm-slim

ARG DB_PORT

RUN apt-get update -y \
 && apt-get install -y --no-install-recommends mariadb-server mariadb-client \
 && rm -rf /var/lib/apt/lists/*

COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY ./conf/entrypoint.sh /entrypoint.sh
RUN chmod 111 /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["mysqld_safe", "--datadir=/var/lib/mysql"]
