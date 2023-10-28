FROM debian:bullseye-slim

# 必要なパッケージをインストール
RUN apt-get update \
    && apt-get install -y \
    curl \
    php-fpm \
    php-gd \
    php-json \
    php-mysql \
    php-curl \
    php-mbstring \
    php-intl \
    php-imagick \
    php-xml \
    php-zip \
    mariadb-client \
    sudo \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# WP-CLIのインストール
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp \
    && wp --allow-root --info

# WordPressのダウンロード
WORKDIR /var/www/html
RUN wp --allow-root core download

# PHP-FPMの設定
RUN sed -i "s/listen = .*/listen = 0.0.0.0:9000/" /etc/php/7.4/fpm/pool.d/www.conf \
    && sed -i "s/^listen.allowed_clients/;listen.allowed_clients/" /etc/php/7.4/fpm/pool.d/www.conf

# PIDファイルのためのディレクトリを作成
RUN mkdir -p /run/php/

# WordPressセットアップスクリプトを追加
COPY ./tools/docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# docker-entrypoint.shを起動
CMD ["/usr/local/bin/docker-entrypoint.sh"]
