# Start med det officielle n8n image
FROM n8nio/n8n:latest

# Skift til root-bruger for at installere pakker
USER root

# Installer ffmpeg ved hjælp af Alpine Linux' pakkehåndtering (apk)
RUN apk add --no-cache ffmpeg

# VIGTIGT: Skift tilbage til den oprindelige, sikre 'node' bruger
USER node
# Installer FFmpeg (statisk version uden afhængigheder)
RUN apt-get update && apt-get install -y wget xz-utils && \
    mkdir -p /usr/local/bin && \
    wget https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-amd64-static.tar.xz -O ffmpeg.tar.xz && \
    tar -xJf ffmpeg.tar.xz && \
    cp ffmpeg-*-amd64-static/ffmpeg /usr/local/bin/ffmpeg && \
    cp ffmpeg-*-amd64-static/ffprobe /usr/local/bin/ffprobe && \
    chmod +x /usr/local/bin/ffmpeg /usr/local/bin/ffprobe && \
    rm -rf ffmpeg.tar.xz ffmpeg-*-amd64-static
