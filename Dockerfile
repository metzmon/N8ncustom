FROM n8nio/n8n:1.37.0

# Fix all permission issues
USER root

# Create alternative storage directory
RUN mkdir -p /usr/app/storage && \
    chown -R node:node /usr/app/storage && \
    chmod -R 777 /usr/app/storage

# Minimal required packages
RUN apk update && apk add --no-cache bash curl chromium

# Force config to new writable location
ENV N8N_CONFIG_PATH=/usr/app/storage \
    N8N_USER_FOLDER=/usr/app/storage \
    RAILWAY_SHELL=enabled \
    PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

# Critical Railway health check
HEALTHCHECK --interval=30s --timeout=10s \
  CMD curl -f http://localhost:5678/healthz || exit 1

USER node
EXPOSE 5678
