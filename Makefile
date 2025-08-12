SERVICE ?= claude   # claude | typescript | ros2 など
PROFILE ?= $(SERVICE)

.PHONY: up build down logs exec ps restart run upexec stop stop-all

up:
	docker compose --profile $(PROFILE) run -d --rm $(SERVICE) zsh

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

run:
	docker compose --profile $(PROFILE) run --rm $(SERVICE) zsh

upexec:
	docker compose --profile $(PROFILE) up -d $(SERVICE) && docker compose exec $(SERVICE) zsh

stop:
	docker compose stop $(SERVICE)

kill-all:
	docker compose down --remove-orphans
