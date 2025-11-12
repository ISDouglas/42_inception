NAME = inception
COMPOSE = docker compose -f ./srcs/docker-compose.yml
SETUP_DIRS = /home/layang/data/wordpress /home/layang/data/mariadb

all: 
	mkdir -p $(SETUP_DIRS)
	build up

build:
	$(COMPOSE) build

up:
	$(COMPOSE) up -d --remove-orphans

down:
	$(COMPOSE) down --volumes --remove-orphans
	rm /home/layang/data/mariadb/.is_initialized

logs:
	$(COMPOSE) logs -f

fclean: down
	docker system prune -af
	docker volume prune -f
	#rm -rf /home/layang/data/mariadb/*
	#rm -rf /home/layang/data/wordpress/*

re: fclean all

.PHONY: all build up down logs fclean re
