FROM python:3.12-slim-bookworm
RUN apt-get update && apt-get install -y --no-install-recommends openscad xvfb x11vnc novnc websockify fluxbox supervisor nginx x11-utils fonts-dejavu ca-certificates && apt-get clean
COPY requirements.lock /opt/requirements.lock
COPY vendor/openscad-mcp /opt/upstream
RUN pip install --no-cache-dir -r /opt/requirements.lock /opt/upstream && useradd -m -u 1000 cad && mkdir -p /workspace /home/cad/.config /tmp/nginx && chown -R cad:cad /workspace /home/cad /tmp/nginx
COPY docker/ /opt/
ENV DISPLAY=:0 HOME=/home/cad QT_X11_NO_MITSHM=1 LIBGL_ALWAYS_SOFTWARE=1 OPENSCAD_PATH=/usr/bin/openscad MCP_TRANSPORT=http MCP_HOST=127.0.0.1 MCP_PORT=8000 MCP_ALLOWED_PATHS=/workspace MCP_TEMP_DIR=/workspace MCP_MAX_CONCURRENT_RENDERS=2 MCP_RENDER_TIMEOUT=120 MCP_MAX_MEMORY_MB=2048
USER cad
WORKDIR /workspace
EXPOSE 8080
HEALTHCHECK --interval=30s --timeout=10s --start-period=45s CMD ["python", "/opt/healthcheck.py"]
CMD ["/bin/sh", "/opt/entrypoint.sh"]

LABEL org.opencontainers.image.source="https://github.com/RexSpex/agent-tool-openscad"
