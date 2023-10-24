#!/bin/bash
set -e # エラーが発生した場合、スクリプトを停止

# 必要な変数を読み込む
: "${WORDPRESS_DB_HOST:?Need to set WORDPRESS_DB_HOST}"
: "${WORDPRESS_DB_USER:?Need to set WORDPRESS_DB_USER}"
: "${WORDPRESS_DB_PASSWORD:?Need to set WORDPRESS_DB_PASSWORD}"
: "${WORDPRESS_DB_NAME:=wordpress}" # Default to 'wordpress' if not set

# MariaDBが起動するまで待機する関数
wait_for_mariadb() {
    while ! mysqladmin ping -h"$WORDPRESS_DB_HOST" --silent; do
        echo "Waiting for mariadb to be available..."
        sleep 5
    done
    echo "MariaDB is up and running."
}

# MariaDBが起動するまで待機
wait_for_mariadb

# WordPressの設定ファイルを生成
if [ ! -f wp-config.php ]; then
    wp --allow-root core config --dbname="${WORDPRESS_DB_NAME}" --dbuser="${WORDPRESS_DB_USER}" --dbpass="${WORDPRESS_DB_PASSWORD}" --dbhost="${WORDPRESS_DB_HOST}"
fi

# WordPressが未インストールの場合、インストールする
if ! $(wp --allow-root core is-installed); then
    wp --allow-root core install --url="${WORDPRESS_URL}" --title="Your WordPress Site" --admin_user="${WORDPRESS_ADMIN_USER}" --admin_password="${WORDPRESS_ADMIN_PASSWORD}" --admin_email="admin@example.com"
    # 一般ユーザー作成
    wp --allow-root user create "${WORDPRESS_USER}" user@example.com --user_pass="${WORDPRESS_PASSWORD}" --role=subscriber
    # 登録ユーザーのみコメントができるように設定
    wp --allow-root option update comment_registration 1
fi

# PHP-FPMを起動
exec php-fpm7.4 -F
