all: build up

build:
	docker compose -f ./srcs/requirements/docker-compose.yml build

up:
	docker compose -f ./srcs/requirements/docker-compose.yml up -d

down:
	docker compose -f ./srcs/requirements/docker-compose.yml down

logs:
	docker compose -f ./srcs/requirements/docker-compose.yml logs -f
