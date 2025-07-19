FROM n8nio/n8n:1.37.0

# 1) Switch to root so we can fix permissions and create folders
USER root

# 2) Create all the writable dirs and default config.json
RUN mkdir -p /home/node/.n8n \
         /data \
         /usr/app/storage/.n8n && \
    # Set up an empty config.json so n8n never errors on missing file
    echo '{}' > /data/config.json && \
    # Give node user ownership and full rw for these paths
    chown -R node:node /home/node /data /usr/app/storage && \
    chmod -R 777 /home/node /data /usr/app/storage

# 3) Install only the minimal packages you need
RUN apk update && \
    apk add --no-cache \
      bash \
      curl \
      chromium

# 4) Point n8n at /data for both its config file and its user folder
ENV N8N_CONFIG_PATH=/data \
    N8N_USER_FOLDER=/data \
    RAILWAY_SHELL=enabled \
    PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

# 5) Healthcheck for Railway
HEALTHCHECK --interval=30s --timeout=10s \
  CMD curl -f http://localhost:5678/healthz || exit 1

# 6) Drop back to the non-root user
USER node

# 7) Expose the port n8n listens on
EXPOSE 5678
