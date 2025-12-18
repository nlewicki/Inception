This project has been created as part of the 42 curriculum by nlewicki.

# User Documentation – Inception
## Overview

This project provides a containerized web infrastructure based on Docker and Docker Compose.
It deploys a secure WordPress website with several supporting services, all connected through
a private Docker network.

The stack is designed so that an end user or administrator can easily start, stop, and verify
the services without needing to understand the internal implementation details.

## Provided Services

The infrastructure includes the following services:

- NGINX – HTTPS reverse proxy and single entry point

- WordPress – Website application running with PHP-FPM

- MariaDB – Database backend for WordPress

- Redis (bonus) – Object caching for WordPress

- FTP (bonus) – File transfer access to WordPress files

- Adminer (bonus) – Web-based database administration

- Portainer (bonus) – Docker container management interface

- Static Site (bonus) – Simple static website served via HTTP

### Starting the Project

From the root of the repository, run:

    make

This will:

- Build all required Docker images

- Create Docker networks and volumes

- Start all services

After this step, the infrastructure is fully running.

### Stopping the Project

To stop all containers and remove images without deleting persistent data, run:

    make clean

This stops the stack while keeping WordPress and database data intact.

### Full Cleanup (Delete All Data)

To completely remove the project, including all persistent data, run:

    make fclean

This will delete:

- Docker containers

- Docker images

- Docker volumes

- All data stored under ~/data

## Accessing the Website and Administration Panel

After the project is running, the services can be accessed as follows:

- Website (User access):

    https://nlewicki.42.fr/

- WordPress Administration Panel:

    https://nlewicki.42.fr/wp-admin

Access is performed through a web browser using HTTPS.

## Accessing the Services
### Website

    URL: https://nlewicki.42.fr

HTTPS only (TLS 1.2 / 1.3)

Self-signed certificate

### Adminer (Database Management)

    URL: http://localhost:8081

### Portainer (Docker Management)

    URL: http://localhost:8082

### Static Website

    URL: http://localhost:8080

### FTP Access

    Port: 21 (control)

    Passive ports: 50000–50100

Credentials are stored securely using Docker secrets

## Credentials & Secrets

All sensitive information (database credentials, WordPress users, FTP credentials, Portainer
admin password) is stored using Docker secrets.

Secret files are located in the secrets/ directory and are never hardcoded into images or
committed to configuration files.


## Verifying That Services Are Running

You can check running containers with:

    docker ps

### You can also verify correct behavior using HTTPS tests:

HTTPS access:

    curl -vk https://nlewicki.42.fr/

HTTP should fail:

    curl -v http://nlewicki.42.fr/

## Summary

This project provides a ready-to-use, secure WordPress infrastructure that can be started,
stopped, and managed easily using Makefile commands and Docker tools.