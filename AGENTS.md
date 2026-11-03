# Agent instructions

Read README.md and AGENT_PROMPT.md before setup or design work.
Run Python 3.10+ scripts from repository directory. Host needs no CAD installation.
Use `python3 scripts/setup.py` to build, select host port, start, and validate.
Keep host binding at 127.0.0.1. Host port defaults to 48321; container port remains 8080.
Preserve .env values, existing MCP entries, unrelated Docker services, and persistent volumes.
Use reported MCP URL. For terminal fallback, use scripts/mcp.py; inspect live tool schemas.
Never treat successful setup as successful design validation.
Create parametric OpenSCAD source under /workspace/models/<project>. Confirm dimensions, units, clearances, and print constraints. Render multiple views and inspect them. Export STL under /workspace/exports/<project>. Check dimensions, volume, and watertightness with MCP tools. Copy source, STL, and PNG previews to my computer. State print or physical checks still pending.
Document tested platforms honestly. Do not add machine-specific paths or private network dependencies.
Keep vendored licenses and source attribution intact.
