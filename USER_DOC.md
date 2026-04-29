# User Documentation
 
## What services are provided?
 
This project runs a complete web infrastructure made of several services, each running in its own Docker container.
 
### Mandatory services
 
| Service | What it does |
|---|---|
| **Nginx** | The front door of the infrastructure. Handles all incoming traffic over HTTPS and forwards requests to WordPress |
| **WordPress** | The website engine. Serves the website and handles all content |
| **MariaDB** | The database. Stores all WordPress content, users, and settings |
 
### Bonus services
 
| Service | What it does |
|---|---|
| **Redis** | Speeds up WordPress by caching database results in memory |
| **Adminer** | A visual interface to browse and manage the database from your browser |
| **Static website** | A simple HTML/CSS website running independently on its own port |
| **FTP server** | Allows direct file access to the WordPress files using an FTP client |
| **cAdvisor** | A real-time dashboard showing CPU, memory and network usage of all containers |
 
---
 
## How to start and stop the project
 
### Start everything
 
```bash
make
```
 
This builds all Docker images and starts all containers. The first run may take a few minutes.
 
### Stop everything
 
```bash
make down
```
 
This stops all containers without deleting any data.
 
```bash
make clean
```
This stops all containers and removes everything without cache.

### Full cleanup (removes everything including data and delete all cache)
 
```bash
make fclean
```
 
> ⚠️ This deletes all volumes and stored data. Your WordPress content and database will be lost.
 
### Restart from scratch
 
```bash
make re
```
 
---
 
## How to access the services
 
Make sure your machine has the following line in `/etc/hosts`:
 
```
127.0.0.1   login.42.fr
```
 
Replace `login` with the actual login used in the project.
 
| Service | URL | Notes |
|---|---|---|
| WordPress website | `https://login.42.fr` | Main website, HTTPS only |
| WordPress admin panel | `https://login.42.fr/wp-admin` | Requires admin credentials |
| Adminer | `http://login.42.fr:8080` | Database management UI |
| Static website | `http://login.42.fr:3000` | Simple HTML page |
| cAdvisor | `http://login.42.fr:8090` | Container monitoring dashboard |
| FTP | `login.42.fr` on port `21` | Requires an FTP client like FileZilla |
 
---
 
## Credentials
 
All credentials are stored in the `secrets/` directory at the root of the project.

 
### WordPress admin login
 
| Field | Value |
|---|---|
| URL | `https://login.42.fr/wp-admin` |
| Username | Value of `WP_ADMIN` in `.env` |
| Password | Value of `WP_ADMIN_PASSWORD` in `secrets/wp_admin_pw.txt` |
 
### Adminer database login
 
Open Adminer at `http://login.42.fr:8080` and fill in:
 
| Field | Value |
|---|---|
| System | MySQL |
| Server | `mariadb` |
| Username | Value of `MARIADB_USER` in `.env` |
| Password | Value of `db_password` in `secrets/db_password.txt` |
| Database | Value of `MARIADB_DATABASE` in `.env` |
 
### FTP login
 
| Field | Value |
|---|---|
| Host | `login.42.fr` |
| Port | `21` |
 
---
 
## How to check that everything is running correctly
 
### Check all containers are up
 
```bash
docker ps
```
 
You should see all containers listed with status `Up`.
 
### Check a specific service's logs
 
```bash
docker logs 'service'
```
 
### Check Redis is actually caching Or By the Monitor Real-Time Activity
 
```bash
docker exec -it redis redis-cli DBSIZE
# This should return a number greater than `0` after visiting the WordPress site a few times.
#Monitor Cmd
docker exec -it redis redis-cli MONITOR
#Refresh your WordPress site
# If you see lines starting with "SET", Redis is saving new data to the cache.
# If you see lines starting with "GET", your application is successfully retrieving data from the cache.
```
 
 
### Check WordPress can reach Redis
 
```bash
docker exec -it wordpress wp redis status --allow-root --path=/var/www/html
```

Expected output: `Status: Connected`
 
### Check the database is reachable
 
```bash
docker exec -it mariadb mysql -u root -p
```
 
Enter the root password from `secrets/db_root_password.txt` when prompted.
