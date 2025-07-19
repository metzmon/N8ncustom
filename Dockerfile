# ==============================================================================
# === STABLE SUPERCHARGED N8N (RAILWAY-PROOF) =================================
# ==============================================================================
ARG N8N_VERSION=1.37.0
FROM n8nio/n8n:${N8N_VERSION}

USER root

# Install all tools
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

# Critical Railway fixes
RUN mkdir -p /home/node/.n8n && \
    chown -R node:node /home/node && \
    chmod -R 755 /home/node

# Health check
HEALTHCHECK --interval=30s --timeout=10s \
    CMD curl -f http://localhost:5678/healthz || exit 1
    
USER node
EXPOSE 5678
