# ==============================================================================
# === N8N "SUPERCHARGED" DOCKERFILE FOR RAILWAY (VERSION 2 - ROBUST SYNTAX) ====
# ==============================================================================
# Formål: At bygge et n8n-image med udvidede funktioner til medie-
#         manipulation, web-scraping/browser-automatisering og andre værktøjer.
# ==============================================================================

# Anvend et ARG-argument til nemt at kunne skifte n8n-version.
# Det anbefales stærkt at låse til en specifik version i produktion.
# Find nyeste versioner her: https://hub.docker.com/r/n8nio/n8n/tags
ARG N8N_VERSION=latest

# Start fra den officielle n8n-image baseret på Alpine Linux for en lille størrelse.
FROM n8nio/n8n:${N8N_VERSION}

# Skift til 'root' brugeren for at få rettigheder til at installere pakker.
USER root

# ==============================================================================
# === INSTALLATION AF SYSTEMPAKKE-AFHÆNGIGHEDER ================================
# ==============================================================================
# Installer alle nødvendige pakker i et enkelt RUN-lag for at optimere caching
# og holde image-størrelsen nede. Hver linje (undtagen den sidste i listen)
# SKAL slutte med et backslash (\) for at signalere, at kommandoen fortsætter.
RUN apk update && apk upgrade && \
    apk add --no-cache \
    # --- Medie-manipulation ---
    ffmpeg \
    graphicsmagick \
    # --- Browser-automatisering og Web-scraping ---
    chromium \
    nss \
    freetype \
    harfbuzz \
    ttf-freefont \
    # --- Værktøjer til 'Execute Command' noden ---
    git \
    jq \
    curl \
    wget \
    zip \
    unzip \
    bash \
    # --- Andre nyttige pakker ---
    python3 \
    py3-pip \
    && \
    # Ryd op i APK cache for at reducere image-størrelsen
    rm -rf /var/cache/apk/*

# ==============================================================================
# === KONFIGURATION AF PUPPETEER TIL AT BRUGE SYSTEMETS CHROMIUM ===============
# ==============================================================================
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

# Porten n8n lytter på internt.
EXPOSE 5678

# Entrypoint og CMD er arvet fra base-imaget.
