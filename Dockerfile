# syntax=docker/dockerfile:1.3

###########################################
# 1) Builder stage: install n8n globally   #
###########################################
ARG N8N_VERSION=1.37.0
FROM node:18-alpine AS builder

# Install build-time deps for any native modules
RUN apk add --no-cache python3 make g++ \
 && npm install -g n8n@$N8N_VERSION

###########################################
# 2) Runtime stage: minimal, secure image #
###########################################
FROM node:18-alpine

##################
# Metadata Labels
LABEL org.opencontainers.image.authors="Your Company <devops@yourcompany.com>" \
      org.opencontainers.image.source="https://github.com/yourorg/docker-n8n" \
      org.opencontainers.image.licenses="Apache-2.0" \
      org.opencontainers.image.version=$N8N_VERSION

###########################
# System utilities & deps
RUN apk add --no-cache \
      dumb-init \          # PID 1 wrapper for proper signal handling \
      chromium \           # headless browser for Puppeteer-driven workflows \
      curl                 # for healthchecks

##############################
# Create & lock down volumes
RUN mkdir -p /home/node/.n8n /data \
 && chown -R node:node /home/node /data \
 && chmod -R 700 /home/node /data

# Switch to non-root
USER node

########################
# Environment variables
ENV NODE_ENV=production \
    N8N_VERSION=${N8N_VERSION} \
    N8N_USER_FOLDER=/home/node/.n8n \
    N8N_CONFIG_PATH=/data \
    PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser \
    TZ=Europe/Copenhagen

###########################
# Copy n8n from the builder
COPY --from=builder --chown=node:node /usr/local/lib/node_modules/n8n /usr/local/lib/node_modules/n8n
COPY --from=builder --chown=node:node /usr/local/bin/n8n              /usr/local/bin/n8n

##################
# Networking
EXPOSE 5678

##################
# Healthcheck
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD curl -f http://localhost:5678/healthz || exit 1

##################
# Entrypoint & CMD
ENTRYPOINT ["dumb-init", "--"]
CMD ["n8n", "start"]
