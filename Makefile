VOLUME_PATH=$(shell grep VOLUME_PATH srcs/.env | cut -d '=' -f2)

all: up

prepare-directories:
	sudo mkdir -p ${VOLUME_PATH}/web
	sudo mkdir -p ${VOLUME_PATH}/db

# コンテナをバックグラウンドで起動
up: prepare-directories
	cd srcs && docker-compose up --build -d

# コンテナのビルド
build:
	cd srcs && docker-compose build

# コンテナを停止
stop:
	cd srcs && docker-compose stop

# コンテナを停止し、すべてのコンテナを削除
down:
	cd srcs && docker-compose down

# コンテナ、イメージ、ボリューム、ネットワークを削除
clean:
	cd srcs && docker-compose down --rmi all --volumes
	sudo rm -rf $(VOLUME_PATH)/web
	sudo rm -rf $(VOLUME_PATH)/db
