SERVICE ?= claude
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

# ボリューム管理用のコマンド
list-volumes:
	docker volume ls | grep $(SERVICE)-history

clean-volumes:
	docker volume ls -q | grep $(SERVICE)-history | xargs -r docker volume rm

# API開発用コマンド
api-up:
	docker compose --profile api up -d

api-down:
	docker compose --profile api down

api-logs:
	docker compose logs -f api-gateway claude

api-build:
	docker compose --profile api build

# テスト用
test-curl:
	@echo "Testing API Gateway..."
	curl -X POST http://localhost:8000/threads/test123/messages \
		-H "Content-Type: application/json" \
		-d '{"text": "Hello World"}' | jq .
	@echo "\nTesting healthz..."
	curl -X GET http://localhost:8000/healthz | jq .
