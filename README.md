*This project has been created as part of the 42 curriculum by ychedmi.*

---

## Description

Inception is a system administration project from the 42 curriculum. The goal is to set up a small infrastructure composed of different services running inside Docker containers, all orchestrated using Docker Compose.

The project runs entirely inside a virtual machine. Every service lives in its own dedicated container, built from scratch using custom Dockerfiles based on Debian.

### What the project sets up

The mandatory part builds a working WordPress website with the following stack:

- **Nginx** — the only entry point, serving the site over HTTPS (TLS 1.2/1.3 only)
- **WordPress + php-fpm** — the website engine, running without Nginx inside its own container
- **MariaDB** — the database storing all WordPress data

The bonus part extends the infrastructure with five additional services:

- **Redis** — object cache for WordPress, reducing database queries
- **FTP server** — direct file access to the WordPress volume via vsftpd
- **Static website** — a simple HTML/CSS site served on its own port, without PHP
- **Adminer** — a lightweight web-based database management UI
- **cAdvisor** — a real-time container resource monitoring dashboard

### Docker
Docker is a tool that packages software into containers, which include everything the app needs to run. This ensures it works exactly the same on any computer while being much faster and lighter than a virtual machine.
The project's primary goal is to teach system administration and DevOps by requiring you to containerize a web stack from scratch.

### Design choices

Every container is built from Debian Bookworm. Services communicate over a private Docker network called `inception_my-network`. Persistent data (WordPress files and MariaDB database) is stored in named Docker volumes mapped to `/home/user/data/` on the host machine. All containers restart automatically unless explicitly stopped.

---

### Virtual Machines vs Docker

| | Virtual Machine | Docker Container |
|---|---|---|
| What it virtualizes | Entire hardware (CPU, RAM, disk) | Only the application and its dependencies |
| Size | Several GB per VM | A few MB per container |
| Boot time | Minutes | Seconds |
| Isolation | Complete — separate OS per VM | Process-level — shares the host kernel |
| Use case | Running different operating systems | Running isolated services on the same OS |

A VM is like renting an entire apartment. Docker is like renting a single room in a shared building — you have your own private space but share the building's foundation.

In this project, the VM provides the base Linux system, and Docker runs isolated services on top of it. Both layers are needed.

---

### Secrets vs Environment Variables

| | Secrets | Environment Variables |
|---|---|---|
| Storage | Encrypted, stored securely (Docker Swarm / Kubernetes) | Plain text in `.env` files or inline in compose |
| Access | Only injected at runtime into authorized containers | Available to any process that reads the environment |
| Security | High — never visible in logs or inspect output | Lower — visible via `docker inspect` |
| Complexity | Requires orchestration setup | Simple, works with basic Docker Compose |

This project uses environment variables via a `.env` file for simplicity, which is acceptable for a school project. In a real production environment, Docker Secrets or a vault solution would be used instead to avoid exposing credentials.

---

### Docker Network vs Host Network

| | Docker Network | Host Network |
|---|---|---|
| Isolation | Containers have their own private network | Containers share the host's network directly |
| Security | High — containers only expose what you explicitly publish | Low — all container ports are exposed to the host |
| Container communication | By container name (internal DNS) | By localhost |
| Port conflicts | Avoided — each container has its own IP | Possible — containers compete for the same ports |

This project uses a custom bridge network called `inception`. Containers talk to each other by name (e.g. WordPress connects to MariaDB using the hostname `mariadb`). Only the necessary ports are published to the host.

Host networking is not used because it would break isolation and expose all services directly to the outside world.

---

### Docker Volumes vs Bind Mounts

| | Docker Volumes | Bind Mounts |
|---|---|---|
| Managed by | Docker | You (a specific host path) |
| Location on host | `/var/lib/docker/volumes/` (automatic) | Any path you specify |
| Portability | High — works on any machine | Lower — depends on the exact host path existing |
| Performance | Optimized by Docker | Same as host filesystem |
| Use case | Persistent application data | Development, sharing specific host files |

This project uses named volumes (`inception_wordpress_vol`, `inception_mariadb_vol`) that are mapped to explicit host paths inside the VM (`/home/user/data/wordpress` and `/home/user/data/mariadb`). This satisfies both the portability of named volumes and the subject's requirement to store data in a specific location on the host.

---

## Instructions

### Requirements

- Docker and Docker Compose installed
- `make` installed

### Setup

1. Clone the repository:

```bash
cd inception
```

2. Create the secrets folder and files for your credentials:

```bash
mkdir -p srcs/secrets
touch srcs/secrets/db_password.txt
touch srcs/secrets/db_root_password.txt
touch srcs/secrets/wp_admin_pw.txt
touch srcs/secrets/wp_user_pw.txt
# Then fill each file with its value.
```

3. Create the `.env` file inside `srcs/`:

```bash
touch srcs/.env
```

Then edit `srcs/.env` and fill in your credentials:

```env
SITE_TITLE=your_site_title

#DB USER INFO
MARIADB_DATABASE="wordpress"
MARIADB_USER=user_db_name
DB_HOST="mariadb"

#DOMAINE NAME
DOMAIN_NAME=your_domaine

# WORDPRESS PATH
WP_PATH=/var/www/html/

#WORDPRESS ADMIN
WP_ADMIN=wp_admin_username
WP_ADMIN_EMAIL=admin@example.com

#WORDPRESS USER
WP_USER=wp_user
WP_USER_EMAIL=user@example.com

#REDIS
REDIS_HOST=redis
REDIS_PORT=6379
```

3. Add your domain to `/etc/hosts` on the VM:

```bash
echo "127.0.0.1 your_domaine" | sudo tee -a /etc/hosts
```

4. Build and start all containers:

```bash
make
```

### Available make commands

```bash
make          # build and start all containers
make down     # stop all containers
make clean    # stop containers and remove images and docker volumes
make fclean   # full cleanup including volumes and caches
make re       # full rebuild from scratch
```

### Accessing the services

| Service | URL |
|---|---|
| WordPress | https://your_domaine |
| Adminer | http://your_domaine:8080 |
| Static website | http://your_domaine:3000 |
| cAdvisor | http://your_domaine:8090 |
| FTP | ftp://your_domaine:21 |

---

## Resources

### Docker & Docker Compose
- [Docker official documentation](https://docs.docker.com)
- [Docker Compose reference](https://docs.docker.com/compose/compose-file/)
- [Dockerfile best practices](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)

### Nginx
- [Nginx beginner's guide](https://nginx.org/en/docs/beginners_guide.html)
- [Nginx ssl_certificate configuration](https://nginx.org/en/docs/http/ngx_http_ssl_module.html)

### WordPress & php-fpm
- [WordPress CLI documentation](https://wp-cli.org/)
- [php-fpm configuration](https://www.php.net/manual/en/install.fpm.configuration.php)

### MariaDB
- [MariaDB Docker setup guide](https://mariadb.com/kb/en/installing-and-using-mariadb-via-docker/)

### Redis
- [Redis documentation](https://redis.io/docs/)
- [Redis Object Cache WordPress plugin](https://wordpress.org/plugins/redis-cache/)

### vsftpd
- [Ftp explaination](https://www.geeksforgeeks.org/computer-networks/file-transfer-protocol-ftp-in-application-layer/)
- [vsftpd configuration reference](https://security.appspot.com/vsftpd/vsftpd_conf.html)

### cAdvisor
- [cAdvisor GitHub repository](https://github.com/google/cadvisor)

### Adminer
- [Adminer official site](https://www.adminer.org/)



---

### Use of AI

Claude and gemini and brave was used throughout this project as a learning and debugging companion. Specifically:

- **Understanding concepts** — Docker networking, volume sharing, php-fpm configuration, FTP passive mode, and the sites-available/sites-enabled Nginx pattern were all explained and clarified through conversation
- **Debugging** — errors like Redis protected mode, wp-config.php environment variable issues, and FTP passive port configuration
- **Configuration files** — initial drafts of `vsftpd.conf`, `redis.conf`, and Nginx configs and manually understood and adjusted

AI was used as a tool to understand concepts deeply, not to blindly copy solutions. Every configuration was manually reviewed, tested, and adjusted to fit the specific project requirements.