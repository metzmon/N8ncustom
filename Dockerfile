# ==============================================================================
# === N8N "SUPERCHARGED" DOCKERFILE FOR RAILWAY (STABLE VERSION) ==============
# ==============================================================================
# Maintains all your tools and adds Railway-specific fixes
# ==============================================================================

ARG N8N_VERSION=1.37.0
FROM n8nio/n8n:${N8N_VERSION}

# Switch to root for installations
USER root

# Install all packages in single layer (your original set)
RUN apk update && apk upgrade && \
    apk add --no-cache \
    ffmpeg \
    graphicsmagick \
    chromium \
    nss \
    freetype \
    harfbuzz \
    ttf-freefont \
    git \
    jq \
    curl \
    wget \
    zip \
    unzip \
    bash \
    python3 \
    py3-pip \
    && rm -rf /var/cache/apk/*

# Configure Puppeteer
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

# Railway-specific fixes
RUN mkdir -p /home/node/.n8n && \
    chown -R node:node /home/node && \
    chmod -R 755 /home/node

# Enable Railway shell and health check
ENV RAILWAY_SHELL=enabled \
    N8N_HOST=0.0.0.0
HEALTHCHECK --interval=30s --timeout=10s \
    CMD curl -f http://localhost:5678/healthz || exit 1

# Switch back to non-root user
USER node
EXPOSE 5678
