yml_path = srcs/docker-compose.yml

all:
	@mkdir -p ~/data/wordpress ~/data/mariadb
	@docker compose --file $(yml_path) up --build -d

down:
	@docker compose --file $(yml_path) down

#stop containers and remove them and images
clean:
	@docker compose --file $(yml_path) down -v --rmi all

#stop containers and remove them and also remove volumes, images // full reset
#--rmi		Remove images used by services. "local" remove only images that don't have a custom tag ("local"|"all")
# prune delete cache 
fclean: down clean
	@docker system prune -af
	@sudo rm -rf ~/data

re: fclean all