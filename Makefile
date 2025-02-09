# カレントディレクトリ名を取得
CURRENT_DIR = $(notdir $(shell pwd))
PWD = $(shell pwd)
IMAGE_NAME = $(CURRENT_DIR)
CONTAINER_NAME = $(CURRENT_DIR)-container
DOCKERFILE_NAME = Dockerfiles/ros2-dockerfile
USERNAME := $(shell whoami)
UID := $(shell id -u)
GID := $(shell id -g)

DOCKER_BUILD_FLAGS ?=

build:
	docker build \
		$(DOCKER_BUILD_FLAGS) \
		--build-arg USERNAME=$(USERNAME) \
		--build-arg USER_UID=$(UID) \
		--build-arg USER_GID=$(GID) \
		--build-arg CONTAINER_NAME=$(CONTAINER_NAME) \
		-f $(DOCKERFILE_NAME) \
		-t $(IMAGE_NAME)-$(USERNAME) Dockerfiles

run:
	docker run \
		-v $(PWD):/workspace \
		-v ~/.ssh:/home/$(USERNAME)/.ssh:ro \
		-v ~/.gitconfig:/home/$(USERNAME)/.gitconfig \
		-v ~/.zsh_history:/home/$(USERNAME)/.zsh_history \
		-v $(PWD)/Dockerfiles/apt-packages.txt:/home/$(USERNAME)/apt-packages.txt \
		--name $(CONTAINER_NAME)-$(USERNAME) \
		--network host \
		-it $(IMAGE_NAME)-$(USERNAME)

exec:
	docker exec -it $(CONTAINER_NAME)-$(USERNAME) zsh

kill:
	docker kill $(CONTAINER_NAME)-$(USERNAME)

rm:
	docker rm $(CONTAINER_NAME)-$(USERNAME)

start:
	docker start $(CONTAINER_NAME)-$(USERNAME)

stop:
	docker stop $(CONTAINER_NAME)-$(USERNAME)

# 同名のファイルが存在しても必ず実行される。buildディレクトリがあっても実行される。
.PHONY: build
