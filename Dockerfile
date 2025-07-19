# ===================================================================
# === N8N “SUPERCHARGED” DOCKERFILE FOR RAILWAY (NO COMMUNITY NODES) ==
# ===================================================================
ARG N8N_VERSION=latest
FROM n8nio/n8n:${N8N_VERSION}

USER root

# 1) System deps for media & headless Chromium
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

# 2) Puppeteer & settings-file lockdown
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser \
    N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=true

# 3) Switch back to the non-root n8n user
USER node

# 4) Expose n8n’s port
EXPOSE 5678

# 5) **Directly start n8n** — NO npm, NO pnpm
ENTRYPOINT ["n8n", "start"]
