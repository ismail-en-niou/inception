all: build up

build:
	docker compose -f /home/ismail/Desktop/inception/srcs/requirements/docker-compose.yml build

up:
	docker compose -f /home/ismail/Desktop/inception/srcs/requirements/docker-compose.yml up -d

down:
	docker compose -f /home/ismail/Desktop/inception/srcs/requirements/docker-compose.yml down

logs:
	docker compose -f /home/ismail/Desktop/inception/srcs/requirements/docker-compose.yml logs -f
