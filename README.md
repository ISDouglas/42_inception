# 🏗️ Inception - 42 School Project

## 📘 Project Overview
**Inception** is a system administration and virtualization project from **42 School**.  
The goal is to learn how to use **Docker** to build and configure a lightweight, secure, and reproducible server infrastructure.  
You must use **Docker Compose** to set up multiple isolated containers running different services on a virtual machine.

---

## 🎯 Objectives
> Build a small infrastructure composed of multiple containers, without using any pre-built images like `nginx:latest`. The debian-bookworm os was used.

### Requirements:
- Use **Docker Compose** for orchestration.  
- Each service must run in its **own container**.  
- Use **Volumes** to persist data.  
- **All images must be built from your own Dockerfiles**.  
- The project must run inside a **virtual machine (VM)**, preferably **Debian**.
- You need to put your own static site (index.html) page in your folder **/home/*login*/data/website/**.

---

## 🧩 Services Overview

| Service | Description |
|----------|-------------|
| **Nginx** | HTTPS reverse proxy and TLS certificate setup |
| **WordPress (php-fpm)** | The main website service |
| **MariaDB** | Database for WordPress |
| **FTP** *(bonus)* | File transfer service |
| **Adminer / Portainer** *(bonus)* | Management panel |
| **cAdvisor** *(bonus)* | Real-time container monitoring tool available on port **8080** |
| **Static website / Monitoring tools** *(bonus)* | Additional services (located under `requirements/bonus/website`) |

---

## 🏗️ Project Structure
```bash
inception/
├── Makefile
├── secrets/ # Sensitive files (at project root, ignored by git)
├── srcs/
│   ├── docker-compose.yml
│   ├── .env # Environment variables (ignored by git)
│   └── requirements/
│       ├── mariadb/
│       │   ├── Dockerfile
│       │   └── conf/
│       │       ├── 50-server.cnf
│       │       └── entrypoint.sh
│       ├── nginx/
│       │   ├── Dockerfile
│       │   └── conf/
│       │       └── default.conf
│       ├── wordpress/
│       │   ├── Dockerfile
│       │   └── conf/
│       │       └── entrypoint.sh
│       └── bonus/
│           ├── adminer/
│           │   └── Dockerfile
│           ├── cadvisor/
│           │   └── Dockerfile
│           ├── ftp/
│           │   ├── Dockerfile
│           │   └── conf/
│           │       └── entrypoint.sh
│           └── website/
│               └── Dockerfile
└── README.md

