#!/bin/bash
set -eo pipefail

# ロギング関数
mysql_log() {
    local type="$1"; shift
    printf '%s [%s] [Entrypoint]: %s\n' "$(date --rfc-3339=seconds)" "$type" "$*"
}

mysql_note() {
    mysql_log Note "$@"
}

mysql_error() {
    mysql_log ERROR "$@"
    exit 1
}

# 環境変数の読み込み
MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD:-"terabu-rootpass"}
MYSQL_DATABASE=${MYSQL_DATABASE:-"wordpress"}
MYSQL_USER=${MYSQL_USER:-"terabu-user"}
MYSQL_PASSWORD=${MYSQL_PASSWORD:-"terabu-pass"}

# 設定の確認
if [ -z "$MYSQL_ROOT_PASSWORD" ]; then
    mysql_error "MYSQL_ROOT_PASSWORD 環境変数が設定されていません。"
fi

# データベースの初期化
if [ ! -d "/var/lib/mysql/mysql" ]; then
    mysql_note "Initializing database..."
    mysqld --initialize-insecure
    mysql_note "Database initialized."
fi

# データベースの起動をバックグラウンドで行う
mysql_note "Starting MariaDB server for setup..."
mysqld --skip-networking --socket="/run/mysqld/mysqld.sock" &
pid="$!"

# MySQLが完全に起動するのを待つ
mysql_note "Waiting for database server to accept connections..."
while ! mysqladmin ping -uroot --silent; do
    sleep 1
done

mysql_note "Creating database: ${MYSQL_DATABASE}"
mysql -uroot -e "CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\` ;"

mysql_note "Creating user: ${MYSQL_USER}"
mysql -uroot -e "CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD' ;"

mysql_note "Granting access to ${MYSQL_DATABASE} database to ${MYSQL_USER} from any host"
mysql -uroot -e "GRANT ALL ON \`$MYSQL_DATABASE\`.* TO '$MYSQL_USER'@'%' ;"
mysql -uroot -e 'FLUSH PRIVILEGES;'

mysql_note "Stopping temporary server..."
if ! kill -s TERM "$pid" || ! wait "$pid"; then
    mysql_error "Unable to shut down temporary server."
fi

# mysqldの実行の前に、"$@"の内容をログに出力
mysql_note "Arguments passed: $@"

# mysqldの実行
mysql_note "Starting MariaDB server..."
exec "$@"
