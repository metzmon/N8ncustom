# ==============================================================================
# === N8N RAILWAY-OPTIMIZED DOCKERFILE (VOLUME PERMISSIONS FIXED) ============
# ==============================================================================
ARG N8N_VERSION=latest
FROM n8nio/n8n:${N8N_VERSION}

# Switch to root for installations and permission fixes
USER root

# Install essential packages
RUN apk update && apk upgrade && \
    apk add --no-cache \
    curl \
    wget \
    jq \
    bash \
    git \
    && \
    rm -rf /var/cache/apk/*

# Fix n8n directory permissions for Railway volumes
RUN mkdir -p /home/node/.n8n && \
    chown -R node:node /home/node/.n8n && \
    chmod -R 755 /home/node/.n8n

# Set proper environment variables
ENV NODE_ENV=production
ENV N8N_LOG_LEVEL=info
ENV GENERIC_TIMEZONE=UTC

# Switch back to node user AFTER fixing permissions
USER node

# Expose n8n port
EXPOSE 5678

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s \
  CMD curl -f http://localhost:5678/healthz || exit 1
