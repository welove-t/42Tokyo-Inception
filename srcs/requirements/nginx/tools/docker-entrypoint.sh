#!/bin/bash

# Replace the DOMAIN_NAME placeholder
sed -i "s/\${DOMAIN_NAME}/${DOMAIN_NAME}/g" /etc/nginx/sites-available/default

# /var/www/htmlの所有者をwww-dataに変更する。
if [ "$(stat -c '%U' /var/www/html)" = "root" ]; then
    chown -R www-data:www-data /var/www/html
fi

# nginx起動
nginx -g 'daemon off;'
