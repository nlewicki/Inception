*This project has been created as part of the 42 curriculum by nlewicki.*

# Inception

## Description

This project sets up a small containerized infrastructure using **Docker** and **Docker Compose**.  
The goal is to deploy a secure WordPress website using multiple isolated services that communicate
through a Docker network.

The infrastructure includes:
- **NGINX** as the single entry point, serving HTTPS traffic (TLS 1.2 / 1.3 only)
- **WordPress** running with **PHP-FPM**
- **MariaDB** as the database backend
- **Docker volumes** for persistent data
- **Docker secrets** for sensitive credentials
- Bonus services such as Redis, FTP, Adminer, Portainer, and a static site

The project demonstrates best practices in containerization, security, networking, and data
persistence.

---

## Instructions

### Prerequisites
- Linux (Debian-based VM recommended)
- Docker
- Docker Compose
- Make

### Setup & Run
From the root of the repository:


    make


  This command:
  Builds all Docker images locally

Creates the required Docker network and volumes

Starts all containers using docker compose

### Stop the project and delete all data

    make fclean

## Resources
### Documentation & References

- https://docs.docker.com/

- https://docs.docker.com/compose/

- https://medium.com/@imyzf/inception-3979046d90a0

- https://medium.com/@ssterdev/inception-guide-42-project-part-i-7e3af15eb671


### Use of AI

AI tools were used as a learning and assistance resource for:

- Understanding Docker, Docker Compose, and container best practices

- Clarifying differences between Docker concepts (networks, volumes, secrets)

- Debugging configuration issues

- Improving documentation clarity

## TLS tests

### TLS 1.0 (should fail)
    curl -vk --tls-max 1.0 https://nlewicki.42.fr/

### TLS 1.1 (should fail)
    curl -vk --tls-max 1.1 https://nlewicki.42.fr/

### TLS 1.2 (should succeed)
    curl -vk --tls-max 1.2 https://nlewicki.42.fr/

## HTTP / HTTPS Checks

### HTTP (should fail or refuse connection)
    curl -v http://nlewicki.42.fr/

### HTTPS (self-signed certificate, allowed with -k)
    curl -vk https://nlewicki.42.fr/




# Project Description & Design Choices
## Why Docker?

Docker allows running services in isolated, lightweight containers while sharing the same kernel.
This makes deployments faster, more reproducible, and easier to maintain compared to traditional
setups.
### Virtual Machines vs Docker

- Virtual Machines run a full OS per instance → heavy and slow

- Docker containers share the host OS kernel → lightweight and fast

### Secrets vs Environment Variables

- Environment variables are used for non-sensitive configuration

- Docker secrets are used for passwords and credentials to avoid exposing them in images or repositories

### Docker Network vs Host Network

- Docker network provides isolation and service name resolution

- Host network is forbidden and bypasses Docker’s isolation mechanisms

### Docker Volumes vs Bind Mounts

- Volumes are managed by Docker and ensure safe persistence

- Bind mounts allow explicit control over storage location

- This project uses bind-mounted volumes under /home/nlewicki/data to ensure persistence across reboots while remaining transparent and easy to inspect

### Provided Services

- NGINX (HTTPS entry point)

- WordPress + PHP-FPM

- MariaDB

- Redis (bonus)

- FTP (bonus)

- Adminer (bonus)

- Portainer (bonus)

- Static website (bonus)