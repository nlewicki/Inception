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
UID=$(shell id -u)
GID=$(shell id -g)

#wenn nur "make" wird automatisch "make up" ausgefuehrt
.DEFAULT_GOAL := up

up:
	@echo "🚀 Starting containers..."
	@$(COMPOSE) up --build

down:
	@echo "🛑 Stopping containers..."
	@$(COMPOSE) down

re: down
	@echo "🔁 Rebuilding containers..."
	@$(COMPOSE) up --build

clean:
	@echo "🧹 Removing containers, networks and images..."
	@$(COMPOSE) down --rmi all

fclean:
	@echo "🔥 Removing everything including volumes..."
	@$(COMPOSE) down --rmi all -v

ps:
	@$(COMPOSE) ps

logs:
	@$(COMPOSE) logs -f
