all: up

# コンテナをバックグラウンドで起動
up:
	cd srcs && docker-compose up -d

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
	docker stop $(docker ps -qa) || true
	docker rm $(docker ps -qa) || true
	docker rmi -f $(docker images -qa) || true
	docker volume rm $(docker volume ls -q) || true
	docker network rm $(docker network ls -q) || true
