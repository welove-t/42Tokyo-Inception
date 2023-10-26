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
	cd srcs && docker-compose down --rmi all --volumes
