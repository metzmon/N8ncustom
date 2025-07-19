# ==============================================================================
# === SUPERCHARGED N8N FOR RAILWAY (SIMPLE VERSION) ===========================
# ==============================================================================
# This gives your n8n extra powers for videos, images, and web scraping
# ==============================================================================

FROM n8nio/n8n:1.37.0

# Switch to admin mode to install tools
USER root

# Install all tools at once
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

# Make Chromium work properly
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

# Fix for Railway shell access
HEALTHCHECK --interval=30s --timeout=10s \
  CMD curl -f http://localhost:5678/healthz || exit 1
ENV RAILWAY_SHELL=enabled

# Switch back to safe mode
USER node

# Open the n8n port
EXPOSE 5678
