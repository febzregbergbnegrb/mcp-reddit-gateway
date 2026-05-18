# Wraps the stdio MCP server `mcp-reddit` as a public Streamable HTTP
# endpoint so it can be added as a Custom Connector on claude.ai.
FROM node:20-slim

# git is required: uvx clones mcp-reddit from GitHub. curl installs uv.
RUN apt-get update && apt-get install -y --no-install-recommends \
        git curl ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install uv (provides uvx). Lands in /root/.local/bin when run as root.
RUN curl -LsSf https://astral.sh/uv/install.sh | sh
ENV PATH="/root/.local/bin:${PATH}"

# supergateway bridges a stdio MCP server to SSE/HTTP. Installed globally
# so there is no runtime npx fetch on cold start.
RUN npm install -g supergateway

# Pre-warm: clone + build mcp-reddit at image-build time so the first
# request is not a multi-minute git clone. Feeding EOF makes the stdio
# server exit cleanly after the build is cached in uv's cache dir.
RUN timeout 600 sh -c "echo '' | uvx --from git+https://github.com/adhikasp/mcp-reddit.git mcp-reddit" || true

# Render/Railway inject PORT. 8000 is the local default.
ENV PORT=8000
EXPOSE 8000

# Streamable HTTP endpoint served at /mcp (what claude.ai connectors expect),
# health at /healthz. --stateful keeps the MCP session across the multi-request
# initialize -> tools/list -> tools/call handshake.
CMD ["sh", "-c", "supergateway --stdio 'uvx --from git+https://github.com/adhikasp/mcp-reddit.git mcp-reddit' --outputTransport streamableHttp --stateful --streamableHttpPath /mcp --port ${PORT:-8000} --cors --healthEndpoint /healthz"]
