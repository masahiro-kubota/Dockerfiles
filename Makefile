# カレントディレクトリ名を取得
CURRENT_DIR = $(notdir $(shell pwd))
PWD = $(shell pwd)
IMAGE_NAME = $(shell echo $(CURRENT_DIR) | tr '[:upper:]' '[:lower:]')
CONTAINER_NAME = $(shell echo $(CURRENT_DIR) | tr '[:upper:]' '[:lower:]')-container
USERNAME := $(shell whoami)
UID := $(shell id -u)
GID := $(shell id -g)

# デフォルトのターゲット
# .envファイルがあればそこから読み込み、なければros2をデフォルトとする
-include .env
DOCKER_TARGET ?= ros2

# Dockerfileのパスを設定
ifeq ($(DOCKER_TARGET),ros2)
	DOCKERFILE_PATH = Dockerfiles/ros2/Dockerfile
	DOCKERFILE_DIR = Dockerfiles/ros2
	APT_PACKAGES_PATH = $(PWD)/Dockerfiles/ros2/apt-packages.txt
else ifeq ($(DOCKER_TARGET),typescript)
	DOCKERFILE_PATH = Dockerfiles/typescript/Dockerfile
	DOCKERFILE_DIR = Dockerfiles/typescript
	APT_PACKAGES_PATH = $(PWD)/Dockerfiles/typescript/apt-packages.txt
endif

DOCKER_BUILD_FLAGS ?=

build:
	docker build \
		$(DOCKER_BUILD_FLAGS) \
		--build-arg USERNAME=$(USERNAME) \
		--build-arg USER_UID=$(UID) \
		--build-arg USER_GID=$(GID) \
		--build-arg CONTAINER_NAME=$(CONTAINER_NAME)-$(DOCKER_TARGET) \
		-f $(DOCKERFILE_PATH) \
		-t $(IMAGE_NAME)-$(DOCKER_TARGET)-$(USERNAME) $(DOCKERFILE_DIR)

run:
	docker run \
		-v $(PWD):/workspace \
		-v ~/.ssh:/home/$(USERNAME)/.ssh:ro \
		-v ~/.gitconfig:/home/$(USERNAME)/.gitconfig \
		-v ~/.zsh_history:/home/$(USERNAME)/.zsh_history \
		-v $(APT_PACKAGES_PATH):/home/$(USERNAME)/apt-packages.txt \
		--name $(CONTAINER_NAME)-$(DOCKER_TARGET)-$(USERNAME) \
		--network host \
		-it $(IMAGE_NAME)-$(DOCKER_TARGET)-$(USERNAME)

exec:
	docker exec -it $(CONTAINER_NAME)-$(DOCKER_TARGET)-$(USERNAME) zsh

kill:
	docker kill $(CONTAINER_NAME)-$(DOCKER_TARGET)-$(USERNAME)

rm:
	docker rm $(CONTAINER_NAME)-$(DOCKER_TARGET)-$(USERNAME)

start:
	docker start $(CONTAINER_NAME)-$(DOCKER_TARGET)-$(USERNAME)

stop:
	docker stop $(CONTAINER_NAME)-$(DOCKER_TARGET)-$(USERNAME)

# デフォルトDOCKER_TARGETを設定
set-target:
	@if [ -z "$(filter-out set-target,$(MAKECMDGOALS))" ]; then \
		echo "Usage: make set-target ros2    # or typescript"; \
	else \
		echo "DOCKER_TARGET=$(filter-out set-target,$(MAKECMDGOALS))" > .env; \
		echo "Default DOCKER_TARGET set to: $(filter-out set-target,$(MAKECMDGOALS))"; \
	fi

# 現在の設定を表示
show-target:
	@echo "Current DOCKER_TARGET: $(DOCKER_TARGET)"

# devcontainer設定のシンボリックリンクを作成
setup-devcontainer:
	@if [ -z "$(filter-out setup-devcontainer,$(MAKECMDGOALS))" ]; then \
		echo "Usage: make setup-devcontainer ros2    # or typescript"; \
	else \
		TARGET=$(filter-out setup-devcontainer,$(MAKECMDGOALS)); \
		mkdir -p "$(PWD)/.devcontainer"; \
		if [ -L "$(PWD)/.devcontainer/devcontainer.json" ]; then \
			rm "$(PWD)/.devcontainer/devcontainer.json"; \
		fi; \
		ln -sf "../Dockerfiles/$$TARGET/$$TARGET-devcontainer.json" "$(PWD)/.devcontainer/devcontainer.json"; \
		echo "Created symlink: .devcontainer/devcontainer.json -> Dockerfiles/$$TARGET/$$TARGET-devcontainer.json"; \
	fi

# ヘルプメッセージ
help:
	@echo "Usage: make [command] [DOCKER_TARGET=ros2|typescript]"
	@echo ""
	@echo "Commands:"
	@echo "  build       - Build Docker image"
	@echo "  run         - Run Docker container"
	@echo "  exec        - Execute shell in running container"
	@echo "  kill        - Kill running container"
	@echo "  rm          - Remove container"
	@echo "  start       - Start stopped container"
	@echo "  stop        - Stop running container"
	@echo "  set-target        - Set default DOCKER_TARGET (ros2 or typescript)"
	@echo "  show-target       - Show current DOCKER_TARGET"
	@echo "  setup-devcontainer - Setup devcontainer configuration symlink"
	@echo ""
	@echo "Setting default DOCKER_TARGET:"
	@echo "  make set-target ros2        # Set default to ROS2"
	@echo "  make set-target typescript  # Set default to TypeScript"
	@echo ""
	@echo "Setting up devcontainer:"
	@echo "  make setup-devcontainer ros2        # Setup for ROS2 development"
	@echo "  make setup-devcontainer typescript  # Setup for TypeScript development"
	@echo ""
	@echo "Current DOCKER_TARGET: $(DOCKER_TARGET)"

# 同名のファイルが存在しても必ず実行される。buildディレクトリがあっても実行される。
.PHONY: build run exec kill rm start stop help set-target show-target setup-devcontainer

# set-targetの引数を処理
ros2 typescript:
	@:
