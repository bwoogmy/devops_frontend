#!/bin/sh
set -e

# Default API URL - will be defined by Traefik routing
API_URL="${API_URL:-/api/v1}"

# Generate env.js for React app
cat > /usr/share/nginx/html/env.js << ENVJS
window.ENV = {
  API_URL: "${API_URL}"
};
ENVJS

# Simple nginx config - static files only
cat > /etc/nginx/conf.d/default.conf << 'NGINXCONF'
server {
    listen 80;
    root /usr/share/nginx/html;
    index index.html;

    location / {
        try_files $uri $uri/ /index.html;
    }

    # Cache static assets
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
}
NGINXCONF

echo "Starting nginx with API_URL=${API_URL}"
exec nginx -g "daemon off;"
