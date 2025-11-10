# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: ilbonnev <ilbonnev@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/10/08 16:02:24 by ilbonnev          #+#    #+#              #
#    Updated: 2025/10/13 11:10:28 by ilbonnev         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

COMPOSE = docker compose -f ./srcs/docker-compose.yml

up:
	./srcs/requirements/utils/init_volumes.sh
	$(COMPOSE) up -d --build

down:
	$(COMPOSE) down

build:
	$(COMPOSE) build

start:
	$(COMPOSE) start

stop:
	$(COMPOSE) stop

logs:
	$(COMPOSE) logs -f

ps:
	$(COMPOSE) ps

clean:
	$(COMPOSE) down -v

fclean: clean
	docker system prune -af || true
	docker volume prune -f || true

re: fclean up

.PHONY: up down build start stop logs ps clean fclean re
