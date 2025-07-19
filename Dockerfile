FROM n8nio/n8n:1.37.0

# Fix all permission issues and create a default config.json
USER root
RUN mkdir -p /home/node/.n8n /data \
    && chown -R node:node /home/node /data \
    && chmod -R 777 /home/node /data \
    && echo '{}' > /data/config.json \
    && chown node:node /data/config.json \
    && chmod 666 /data/config.json

# Minimal required packages
RUN apk update && \
    apk add --no-cache \
      bash \
      curl \
      chromium

# Force config to writable location
ENV N8N_CONFIG_PATH=/data \
    RAILWAY_SHELL=enabled \
    PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

# Critical Railway health check
HEALTHCHECK --interval=30s --timeout=10s \
  CMD curl -f http://localhost:5678/healthz || exit 1

USER node
EXPOSE 5678
