SERVICE ?= typescript   # claude | typescript | ros2 など
PROFILE ?= $(SERVICE)

.PHONY: up build down logs exec ps restart

up:
	docker compose --profile $(PROFILE) up -d $(SERVICE)

build:
	docker compose --profile $(PROFILE) build $(SERVICE)

down:
	docker compose down

logs:
	docker compose logs -f $(SERVICE)

exec:
	docker compose exec $(SERVICE) zsh

ps:
	docker compose ps

restart:
	docker compose restart $(SERVICE)
