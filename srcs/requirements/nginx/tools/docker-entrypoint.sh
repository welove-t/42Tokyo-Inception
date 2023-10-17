#!/bin/bash
# Replace the DOMAIN_NAME placeholder
sed -i "s/\${DOMAIN_NAME}/${DOMAIN_NAME}/g" /etc/nginx/sites-available/default

# Start Nginx
nginx -g 'daemon off;'
