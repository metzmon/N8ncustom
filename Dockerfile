# Start med det officielle n8n image
FROM n8nio/n8n:latest

# Skift til root-bruger for at installere pakker
USER root

# Installer ffmpeg ved hjælp af Alpine Linux' pakkehåndtering (apk)
RUN apk add --no-cache ffmpeg

# VIGTIGT: Skift tilbage til den oprindelige, sikre 'node' bruger
USER node
