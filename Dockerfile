# ==============================================================================
FROM n8nio/n8n:1.37.0

# === CRITICAL FIX STARTS ===
USER root
# === CRITICAL FIX ENDS ===

# Install tools
RUN apk update && \
    apk add --no-cache \
    ffmpeg \
    graphicsmagick \
    chromium \
    git \
    jq \
    curl \
    wget \
    zip \
    unzip \
    bash \
    python3 \
    py3-pip

# === CRITICAL FIX STARTS ===
# Fix permission errors
RUN mkdir -p /home/node/.n8n && \
    chown -R node:node /home/node/.n8n && \
    chmod -R 755 /home/node
# === CRITICAL FIX ENDS ===

# Browser setup
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

# Railway setup
HEALTHCHECK --interval=30s --timeout=10s \
  CMD curl -f http://localhost:5678/healthz || exit 1
ENV RAILWAY_SHELL=enabled

# Switch to non-root user
USER node

EXPOSE 5678
