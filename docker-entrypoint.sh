#!/bin/sh
set -e

# Generate env.js with runtime environment variables
cat > /usr/share/nginx/html/env.js << ENVJS
window.ENV = {
  API_URL: "${API_URL:-/api/v1}"
};
ENVJS

echo "Generated env.js with API_URL=${API_URL:-/api/v1}"

# Start nginx
exec nginx -g "daemon off;"
