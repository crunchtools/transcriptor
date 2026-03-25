# transcriptor Constitution

> **Version:** 1.0.0
> **Ratified:** 2026-03-25
> **Status:** Active
> **Inherits:** [crunchtools/constitution](https://github.com/crunchtools/constitution) v1.4.0
> **Profile:** Forked MCP Server

## Upstream

- **Source:** https://github.com/samson-art/transcriptor-mcp
- **License:** MIT
- **Forked at:** v0.6.8

## Deployment

- **Port:** 8022
- **Env file:** ~/.config/mcp-env/transcriptor.env
- **Credentials:** WHISPER_API_BASE_URL, MCP_PORT, MCP_HOST, WHISPER_MODE

## Patches

- Custom Containerfile using Hummingbird Node.js base (upstream uses node:20-slim)
- Sentry instrumentation removed (no instrument.js import)
- yt-dlp installed as standalone binary (no Python/Deno in image)
