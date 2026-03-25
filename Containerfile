# Upstream: https://github.com/samson-art/transcriptor-mcp
# License: MIT
# Build:   podman build -f Containerfile -t quay.io/crunchtools/transcriptor .
# Run:     podman run --rm --network host -e MCP_PORT=8022 quay.io/crunchtools/transcriptor

# --- Build stage ---
FROM quay.io/hummingbird/nodejs:22-builder AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Download yt-dlp standalone binary (includes bundled Python — no system Python needed)
RUN curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp_linux \
    -o /tmp/yt-dlp && chmod +x /tmp/yt-dlp

# --- Runtime stage ---
FROM quay.io/hummingbird/nodejs:22

LABEL name="transcriptor" \
      summary="MCP server for YouTube/video transcript extraction" \
      maintainer="crunchtools.com" \
      url="https://github.com/crunchtools/transcriptor" \
      org.opencontainers.image.source="https://github.com/crunchtools/transcriptor" \
      org.opencontainers.image.licenses="MIT"

WORKDIR /app

# Copy yt-dlp standalone binary from builder
COPY --from=builder /tmp/yt-dlp /usr/local/bin/yt-dlp

COPY package*.json ./
RUN npm ci --omit=dev --ignore-scripts && npm cache clean --force
COPY --from=builder /app/dist ./dist

EXPOSE 8000

# Skip instrument.js (Sentry telemetry) — run mcp-http.js directly
ENTRYPOINT ["node"]
CMD ["dist/mcp-http.js"]
