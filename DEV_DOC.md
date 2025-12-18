This project has been created as part of the 42 curriculum by nlewicki.

# Developer Documentation – Inception
## Purpose

This document explains how developers can set up, build, run, and maintain the Inception
infrastructure from scratch. It also describes where data is stored and how Docker resources
are managed.

## Prerequisites

The following tools are required:

- Linux (Debian-based system recommended)

- Docker

- Docker Compose


## Project Structure

The project is structured as follows:

- srcs/ – Docker Compose file and service definitions

- srcs/requirements/ – Dockerfiles and configuration per service

- srcs/requirements/bonus/ – Bonus services

- secrets/ – Docker secret files (credentials)

- Makefile – Project lifecycle management

### Building and Launching the Project

To build and start the entire infrastructure, run:

    make

Internally, this will:

- Build all Docker images locally

- Create Docker networks

- Create and mount volumes

- Load secrets

- Start all services using Docker Compose

- Managing the Stack

### Stop and Clean (Keep Data)

    make clean

Stops all containers

Removes Docker images

Keeps volumes and persistent data

### Full Reset (Delete Everything)

    make fclean

Stops all containers

Removes images and volumes

Deletes bind-mounted data under ~/data

Resets the project to a clean state

### Docker Compose Usage

Developers can manually inspect or control services using:

    docker compose -f srcs/docker-compose.yml ps - to check if every service runs correctly

    docker compose -f srcs/docker-compose.yml logs

    docker compose -f srcs/docker-compose.yml down

## Networking

All services communicate through a custom Docker bridge network.

Containers resolve each other via service names

Host networking is not used

Only explicitly mapped ports are exposed to the host

Data Persistence

Persistent data is stored using bind-mounted volumes located under:

    ~/data/mariadb

    ~/data/wordpress

    ~/data/portainer

This ensures:

- Data survives container restarts

- Data is transparent and easy to inspect

- Full cleanup is possible via make fclean

- Secrets Management

### Secrets are handled using Docker secrets:

- Database credentials

- WordPress admin/user credentials

- FTP credentials

- Portainer admin password

Secrets are injected at runtime and never stored in images or environment variables.

## TLS & Security

NGINX is the only exposed entry point

HTTPS is enforced

Only TLS 1.2 and TLS 1.3 are allowed

HTTP traffic is refused

Self-signed certificates are used

TLS verification can be tested with:

    curl -vk --tls-max 1.2 https://nlewicki.42.fr/
