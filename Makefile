# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: nicolewicki <nicolewicki@student.42.fr>    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/08/06 12:38:19 by nicolewicki       #+#    #+#              #
#    Updated: 2025/08/12 13:39:35 by nicolewicki      ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

NAME=inception
COMPOSE=docker-compose -f srcs/docker-compose.yml

#wenn nur "make" wird automatisch "make up" ausgefuehrt
.DEFAULT_GOAL := up

setup:
	@mkdir -p ~/data/mariadb
	@mkdir -p ~/data/wordpress
	@mkdir -p ~/data/portainer
	@echo "Directories created"

build: setup
	@echo "Building images..."
	@$(COMPOSE) build

up: setup
	@echo "Starting containers..."
	@$(COMPOSE) up -d

down:
	@echo "Stopping containers..."
	@$(COMPOSE) down

re: down
	@echo "Rebuilding containers..."
	@$(COMPOSE) up -d --build

clean:
	@echo "Removing containers, networks and images..."
	@$(COMPOSE) down --rmi all

fclean:
	@echo "Removing everything including volumes..."
	@$(COMPOSE) down --rmi all -v
	@sudo rm -rf ~/data/mariadb ~/data/wordpress ~/data/portainer
	@echo "All data deleted"

all: up

ps:
	@$(COMPOSE) ps

logs:
	@$(COMPOSE) logs -f


.PHONY: setup build up down re clean fclean ps logs

#docker image ls

#docker image ls -f dangling=true
#docker image prune
