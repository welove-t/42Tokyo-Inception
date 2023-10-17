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
MYSQL_DATABASE=${MYSQL_DATABASE:-"terabu-db"}
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

# mysqldの実行の前に、"$@"の内容をログに出力
mysql_note "Arguments passed: $@"

# mysqldの実行
mysql_note "Starting MariaDB server..."
exec "$@"
