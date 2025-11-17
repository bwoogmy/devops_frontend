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
  # Docker Compose mode
  NGINX_PROXY_CONFIG="proxy_pass http://${BACKEND_HOST}:${BACKEND_PORT:-8000};"
else
  # Kubernetes mode
  NGINX_PROXY_CONFIG="resolver kube-dns.kube-system.svc.cluster.local valid=30s;
        set \$backend \"${K8S_BACKEND_SERVICE:-twitter-clone-backend.default.svc.cluster.local}\";
        proxy_pass http://\$backend:8000;"
fi

envsubst '${NGINX_PROXY_CONFIG}' < /etc/nginx/conf.d/nginx.conf.template > /etc/nginx/conf.d/default.conf

echo "Generated nginx config for API_URL=${API_URL:-/api/v1}"

exec nginx -g "daemon off;"
