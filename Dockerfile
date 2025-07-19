# ==============================================================================
# === N8N "SUPERCHARGED" DOCKERFILE FOR RAILWAY (FINAL FIXED VERSION) =========
# ==============================================================================

ARG N8N_VERSION=latest
FROM n8nio/n8n:${N8N_VERSION}

# --- System dependencies ---
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
    && rm -rf /var/cache/apk/*

# --- Custom nodes installation into proper extension path ---
# 0. Install pnpm globally first (required)
RUN npm install -g pnpm

# 1. Install custom nodes properly
RUN mkdir -p /home/node/.n8n/custom-nodes && \
    cd /home/node/.n8n/custom-nodes && \

# --- Make sure n8n loads those nodes ---
ENV N8N_CUSTOM_EXTENSIONS=/home/node/.n8n/custom-nodes

# --- Puppeteer / Chromium setup ---
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

# --- Permissions ---
RUN chown -R node:node /home/node/.n8n
USER node

EXPOSE 5678
