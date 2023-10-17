#!/bin/bash
set -e # エラーが発生した場合、スクリプトを停止

# 必要な変数を読み込む
: "${WORDPRESS_DB_HOST:?Need to set WORDPRESS_DB_HOST}"
: "${WORDPRESS_DB_USER:?Need to set WORDPRESS_DB_USER}"
: "${WORDPRESS_DB_PASSWORD:?Need to set WORDPRESS_DB_PASSWORD}"
: "${WORDPRESS_DB_NAME:=wordpress}" # Default to 'wordpress' if not set

# WordPressの設定ファイルを生成
if [ ! -f wp-config.php ]; then
    wp --allow-root core config --dbname="${WORDPRESS_DB_NAME}" --dbuser="${WORDPRESS_DB_USER}" --dbpass="${WORDPRESS_DB_PASSWORD}" --dbhost="${WORDPRESS_DB_HOST}"
fi

# WordPressが未インストールの場合、インストールする
if ! $(wp --allow-root core is-installed); then
    wp --allow-root core install --url="localhost" --title="Your WordPress Site" --admin_user="admin" --admin_password="password" --admin_email="admin@example.com"
fi

# PHP-FPMを起動
exec php-fpm7.4 -F
