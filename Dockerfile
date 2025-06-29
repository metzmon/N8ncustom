# ==============================================================================
# === N8N "SUPERCHARGED" DOCKERFILE FOR RAILWAY ================================
# ==============================================================================
# Formål: At bygge et n8n-image med udvidede funktioner til medie-
#         manipulation, web-scraping/browser-automatisering og andre værktøjer.
#
# Forfatter: Gemini AI
# Dato: 27. juni 2025
# ==============================================================================

# Anvend et ARG-argument til nemt at kunne skifte n8n-version.
# Det anbefales stærkt at låse til en specifik version i produktion.
# Find nyeste versioner her: https://hub.docker.com/r/n8nio/n8n/tags
ARG N8N_VERSION=1.45.1

# Start fra den officielle n8n-image baseret på Alpine Linux for en lille størrelse.
FROM n8nio/n8n:${N8N_VERSION}

# Skift til 'root' brugeren for at få rettigheder til at installere pakker.
# n8n's standard entrypoint skifter selv tilbage til den sikre 'node' bruger ved opstart.
USER root

# ==============================================================================
# === INSTALLATION AF SYSTEMPAKKE-AFHÆNGIGHEDER ================================
# ==============================================================================
# Installer alle nødvendige pakker i et enkelt RUN-lag for at optimere caching
# og holde image-størrelsen nede.
RUN apk update && apk upgrade && \
    apk add --no-cache \
    # --- Medie-manipulation ---
    ffmpeg \           # Til video- og lyd-konvertering/behandling (essentielt for mange medie-workflows)
    graphicsmagick \   # Til n8n's indbyggede 'Image' node (resize, crop, rotate, etc.)

    # --- Browser-automatisering og Web-scraping ---
    chromium \         # Headless browser til at generere PDFs, tage screenshots og køre browser-automatisering
    nss \              # Nødvendig afhængighed for Chromium
    freetype \         # Nødvendig afhængighed for Chromium
    harfbuzz \         # Nødvendig afhængighed for Chromium
    ttf-freefont \     # Standard fonte for at undgå fejl ved PDF-generering og rendering

    # --- Værktøjer til 'Execute Command' noden ---
    git \              # Til at klone repositories eller interagere med Git
    jq \               # Et kraftfuldt kommandolinje-værktøj til at parse og manipulere JSON
    curl \             # Standardværktøj til at lave HTTP-requests fra kommandolinjen
    wget \             # Alternativ til curl for at downloade filer
    zip \              # Til at komprimere filer
    unzip \            # Til at udpakke filer
    bash \             # Et mere avanceret shell end standard 'sh' i Alpine

    # --- Andre nyttige pakker ---
    python3 \          # Til at køre Python-scripts
    py3-pip \          # Til at installere Python-pakker
    && \
    # Ryd op i APK cache for at reducere image-størrelsen
    rm -rf /var/cache/apk/*

# ==============================================================================
# === KONFIGURATION AF PUPPETEER TIL AT BRUGE SYSTEMETS CHROMIUM ===============
# ==============================================================================
# n8n bruger Puppeteer til browser-automatisering. Disse environment-variable
# fortæller Puppeteer, at den skal bruge den Chromium, vi lige har installeret,
# i stedet for at prøve at downloade sin egen.
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

# Porten n8n lytter på internt. Railway håndterer den eksterne port-mapping.
EXPOSE 5678

# Entrypoint og CMD er arvet fra base-imaget (n8nio/n8n).
# De sørger for at starte n8n-applikationen korrekt som 'node' brugeren.
# Derfor skal vi IKKE tilføje CMD eller ENTRYPOINT her.
