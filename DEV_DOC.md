# Developer Documentation

## Prerequisites

Before setting up the project, make sure the following are installed on your virtual machine:

```bash
# Check Docker is installed
docker --version

# Check Docker Compose is installed
docker compose version

# Check make is installed
make --version
```

If any of these are missing:

```bash
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin make
```

Also add your user to the Docker group to avoid using `sudo` every time:

```bash
sudo usermod -aG docker $USER
# then log out and back in for the change to take effect
```


## Setting up the environment from scratch

### 1. Clone the repository

```bash
git clone https://github.com/hellowdev/inception
cd inception
```
### 2. Create the secrets folder and files for your credentials:

```bash
mkdir -p srcs/secrets
touch srcs/secrets/db_password.txt
touch srcs/secrets/db_root_password.txt
touch srcs/secrets/wp_admin_pw.txt
touch srcs/secrets/wp_user_pw.txt
# Then fill each file with value.
```

### 3. Create the `.env` file

The `.env` file is not included in the repository. Create it manually inside `srcs/`:

```bash
touch srcs/.env
```

Fill it with the following variables:

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

> ⚠️ The `secrets` and `.env` file must never be committed to git. Verify `.gitignore` contains `srcs/.env` and `secrets` (folder).

### 3. Add domain to `/etc/hosts`

```bash
echo "127.0.0.1 your_domaine" | sudo tee -a /etc/hosts
```

### 4. Create the data directories

The volumes store data on the host at `/home/login/data/`. Create these directories:

```bash
mkdir -p /home/$USER/data/wordpress
mkdir -p /home/$USER/data/mariadb
```

---

## Building and launching the project

### Build all images and start containers

```bash
make
```

This runs `docker compose up --build -d` from the `srcs/` directory.

### Build a single service

```bash
docker compose -f srcs/docker-compose.yml build wordpress
```

### Start a single service

```bash
docker compose -f srcs/docker-compose.yml up -d wordpress
```

---

## Makefile reference

| Command | What it does |
|---|---|
| `make` | Build images and start all containers |
| `make down` | Stop all containers |
| `make clean` | Stop containers and remove images |
| `make fclean` | Full cleanup — removes containers, images, and volumes |
| `make re` | `fclean` then full rebuild |
---

## Managing containers

### View running containers

```bash
docker ps
```

### Enter a container

```bash
docker exec -it nginx bash
docker exec -it wordpress bash
docker exec -it mariadb bash
docker exec -it redis bash
```

### View logs of a container

```bash
docker logs nginx
docker logs wordpress -f     # -f to follow live
```

### Restart a single container

```bash
docker compose -f srcs/docker-compose.yml restart nginx
```

### Rebuild a single container after changes

```bash
docker compose -f srcs/docker-compose.yml up -d --build nginx
```

---

## Managing volumes

### List all volumes

```bash
docker volume ls
```

### Inspect a volume

```bash
docker volume inspect inception_wordpress_vol
docker volume inspect inception_mariadb_vol
```

### Remove all volumes (deletes all data)

```bash
docker volume rm inception_wordpress_vol inception_mariadb_vol
```

Or use:

```bash
make fclean
```

---

## Where data is stored and how it persists

This project uses two named Docker volumes mapped to explicit paths on the host:

| Volume | Host path | What it stores |
|---|---|---|
| `wordpress` | `/home/login/data/wordpress` | WordPress PHP files, themes, plugins, uploads |
| `mariadb` | `/home/login/data/mariadb` | MariaDB database files |

### Why named volumes and not bind mounts?

Named volumes are managed by Docker and work consistently across environments. Mapping them to explicit host paths, while keeping the Docker Compose configuration portable.

### What persists across restarts?

| Data | Persists? | Why |
|---|---|---|
| WordPress files | ✅ Yes | Stored in `wordpress` volume |
| Database content | ✅ Yes | Stored in `mariadb` volume |
| Redis cache | ❌ No | Intentional — cache is rebuilt automatically |
| Container logs | ❌ No | Lost on container removal |

### Verify data is persisting correctly

```bash
# stop and restart everything
make down
make
# your WordPress site and all content should still be there
```

---

## Useful debugging commands

```bash
# check a container's environment variables
docker exec -it wordpress env

# check Redis is receiving cache keys
docker exec -it redis redis-cli DBSIZE

# check MariaDB tables
docker exec -it mariadb mysql -u root -p -e "SHOW DATABASES;"
```