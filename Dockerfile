# ==============================================================================
# === N8N "SUPERCHARGED" DOCKERFILE FOR RAILWAY (FINAL VERSION) ====
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
    && \
    rm -rf /var/cache/apk/*

# --- Manual node installation ---
# 1. Create custom nodes directory
RUN mkdir -p /usr/local/lib/node_modules/n8n/node_modules

# 2. Install directly into n8n's node_modules
RUN cd /usr/local/lib/node_modules/n8n && \
    pnpm install n8n-nodes-elevenlabs@latest \
                 n8n-nodes-openai@latest \
                 n8n-nodes-google-drive@latest

# --- Environment setup ---
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser
EXPOSE 5678

# --- Final setup ---
USER node
