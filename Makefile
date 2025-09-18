all: build up

build:
	docker compose -f /Users/ien-niou/Desktop/inception/srcs/requirements/docker-compose.yml build

up:
	docker compose -f /Users/ien-niou/Desktop/inception/srcs/requirements/docker-compose.yml up -d

down:
	docker compose -f /Users/ien-niou/Desktop/inception/srcs/requirements/docker-compose.yml down

logs:
	docker compose -f /Users/ien-niou/Desktop/inception/srcs/requirements/docker-compose.yml logs -f
