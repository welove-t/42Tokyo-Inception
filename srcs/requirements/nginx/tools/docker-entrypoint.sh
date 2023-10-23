#!/bin/bash

# Replace the DOMAIN_NAME placeholder
sed -i "s/\${DOMAIN_NAME}/${DOMAIN_NAME}/g" /etc/nginx/sites-available/default

# Change ownership of /var/www/html to www-data, if it's owned by root
# This is necessary because mounted volumes will inherit the ownership from the host
# and they are often owned by root.
if [ "$(stat -c '%U' /var/www/html)" = "root" ]; then
    chown -R www-data:www-data /var/www/html
fi

# Start Nginx
nginx -g 'daemon off;'
