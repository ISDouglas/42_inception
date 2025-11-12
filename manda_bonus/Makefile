#------------------------------------------------
#Test mariadb without adminer:
#------------------------------------------------
# mysql -u root -p
# SHOW DATABASES;
# USE wordpress_mariadb;
# SELECT * FROM wp_users;
# USE mysql;
# SHOW TABLES;
# SELECT User, Host FROM user;

#test adminer:
# System	MySQL
# Server	mariadb
# Username	wp_db_user
# Password	pwpwpw

#test cadvisor
# http://layang.42.fr:8080

NAME = inception
COMPOSE = docker compose -f ./srcs/docker-compose.yml
SETUP_DIRS = /home/layang/data/wordpress /home/layang/data/mariadb

setup:
	mkdir -p $(SETUP_DIRS)

all: setup build up

build:
	$(COMPOSE) build

stop:
	$(COMPOSE) stop

up:
	$(COMPOSE) up -d --remove-orphans

ps:
	$(COMPOSE) ps

down:
	$(COMPOSE) down --volumes --remove-orphans
	sudo rm -f /home/layang/data/mariadb/.is_initialized
	sudo rm -f /home/layang/data/wordpress/wp-content/object-cache.php
	sudo rm -rf /home/layang/data/wordpress/wp-content/plugins/redis-cache

logs:
	$(COMPOSE) logs -f

prune: down
	docker system prune -af
	docker volume prune -f
	sudo rm -rf /home/layang/data/mariadb/* || true
	sudo rm -rf /home/layang/data/wordpress/* || true

fclean: down
	sudo rm -rf /home/layang/data/mariadb/* || true
	sudo rm -rf /home/layang/data/wordpress/* || true

re: fclean all

.PHONY: all build up ps down logs fclean re stop prune setup
