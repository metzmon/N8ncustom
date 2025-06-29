# =================================================================
# Production-Ready Dockerfile for n8n on Railway
# with FFmpeg and Community Nodes
# =================================================================

# Stage 1: Base Image
# Use a specific, pinned version of the official n8n image for build stability.
# Avoid 'latest' in production. Find tags at: https://hub.docker.com/r/n8nio/n8n/tags
FROM n8nio/n8n:latest

# Switch to the root user to gain privileges for system package installation.
USER root

# Stage 2: Install System Dependencies (FFmpeg)
# Update package lists, install FFmpeg without recommended packages to keep the image lean,
# and then clean up apt cache to reduce the final image size. This entire sequence
# is run in a single RUN command to create a single, efficient layer.
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends ffmpeg && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Stage 3: Install Community Node Packages
# Install the desired community node package(s) globally using npm.
# This example installs 'n8n-nodes-mcp', which provides access to hundreds of tools.
# You can add more 'npm install -g' commands for other packages on separate lines.
RUN npm install -g n8n-nodes-mcp

# Stage 4: Revert to Non-Privileged User
# Switch back to the non-privileged 'node' user for enhanced security during runtime.
# The main n8n application will execute as this user.
USER node
