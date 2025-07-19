# ==============================================================================
# === N8N "SUPERCHARGED" DOCKERFILE FOR RAILWAY (VERSION 2 - ROBUST SYNTAX) ====
# ==============================================================================
# Formål: At bygge et n8n-image med udvidede funktioner til medie-
#         manipulation, web-scraping/browser-automatisering og andre værktøjer.
# ==============================================================================

ARG N8N_VERSION=latest
FROM n8nio/n8n:${N8N_VERSION}

USER root

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
    && \
    rm -rf /var/cache/apk/*
    
# Install community nodes globally via npm
RUN npm install -g --unsafe-perm \
      n8n-nodes-elevenlabs@latest \
      n8n-nodes-openai@latest \
      n8n-nodes-google-drive@latest \
    && npm cache clean --force
    
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

EXPOSE 5678
