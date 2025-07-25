# ==============================================================================
# === N8N RAILWAY-OPTIMIZED DOCKERFILE (STABLE & LIGHTWEIGHT) ================
# ==============================================================================
ARG N8N_VERSION=1.0.5
FROM n8nio/n8n:${N8N_VERSION}

# Switch to root for installations
USER root

# Install only essential packages to avoid conflicts
RUN apk update && apk upgrade && \
    apk add --no-cache \
    curl \
    wget \
    jq \
    bash \
    git \
    && \
    rm -rf /var/cache/apk/*

# Set proper environment variables
ENV NODE_ENV=production
ENV N8N_LOG_LEVEL=info
ENV GENERIC_TIMEZONE=UTC

# Switch back to node user for security
USER node

# Expose n8n port
EXPOSE 5678

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s \
  CMD curl -f http://localhost:5678/healthz || exit 1
