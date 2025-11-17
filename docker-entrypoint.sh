#!/bin/sh
set -e

# Generate env.js
cat > /usr/share/nginx/html/env.js << ENVJS
window.ENV = {
  API_URL: "${API_URL:-/api/v1}"
};
ENVJS

# Generate nginx config based on environment
if [ -n "$BACKEND_HOST" ]; then
  # Docker Compose mode - direct proxy
  cat > /etc/nginx/conf.d/default.conf << NGINXCONF
server {
    listen 80;
    root /usr/share/nginx/html;
    index index.html;

    location / {
        try_files \$uri \$uri/ /index.html;
    }

    location /api {
        proxy_pass http://${BACKEND_HOST}:${BACKEND_PORT:-8000};
    }
}
NGINXCONF
else
  # Kubernetes mode - with resolver
  cat > /etc/nginx/conf.d/default.conf << 'NGINXCONF'
server {
    listen 80;
    root /usr/share/nginx/html;
    index index.html;

    location / {
        try_files $uri $uri/ /index.html;
    }

    location /api {
        resolver kube-dns.kube-system.svc.cluster.local valid=30s;
        set $backend "twitter-clone-backend.default.svc.cluster.local";
        proxy_pass http://$backend:8000\;
    }
}
NGINXCONF
fi

echo "Generated nginx config for API_URL=${API_URL:-/api/v1}"

exec nginx -g "daemon off;"
