#!/bin/bash

docker stop mariadb nginx wordpress

docker rm $(docker ps -aq) #remove cont

docker rmi $(docker image ls -aq) #remove images

docker volume rm inception_mariadb inception_wordpress #remve dock volume

sudo rm -rf /home/ychedmi/data/mariadb/* /home/ychedmi/data/wordpress/* #remove host volume

docker compose down -v

# docker compose build --no-cache #remove cahe

# docker compose up --build
