# Build a design with openscad

Replace design placeholder. Paste this prompt into an agent with terminal access to your computer.

```text
Build this design: <DESCRIBE DESIGN, DIMENSIONS OR ELECTRICAL REQUIREMENTS>.

Use https://github.com/RexSpex/agent-tool-openscad on this computer.

1. Detect OS, shell, CPU architecture, Git, Docker, Compose v2, and Python 3.10+.
   Install missing prerequisites through supported OS methods and follow approval rules.
   Start Docker using Linux containers. Never ask for credentials in chat.
   Docker needs 5 GiB available memory; leave room for other running services.
   Use native Docker architecture where supported.
2. Clone https://github.com/RexSpex/agent-tool-openscad.git into a suitable local projects directory, or reuse its matching checkout.
   Read README.md and AGENTS.md. Preserve existing local files and settings.
3. Run python3 scripts/setup.py from repository directory (use python or py -3 on Windows).
   Setup builds Docker image, starts service, checks port availability, and runs smoke checks.
   Default host port is 48321; setup selects another free port if occupied and saves it in .env.
   Read reported URLs. Never assume default port after setup.
4. Connect this harness to reported /mcp URL using Streamable HTTP.
   Read this harness's current official MCP documentation or CLI help for exact configuration syntax.
   Preserve existing servers; prefer project scope when supported. Verify real tool calls through harness.
   If MCP connection needs restart, state exact restart step and pending verification.
   Continue design through scripts/mcp.py when terminal access works but native MCP is unavailable.
   Run python3 scripts/mcp.py --url <reported-mcp-url> list for tool names and argument schemas.
   Run python3 scripts/mcp.py --url <reported-mcp-url> call <tool-name> @arguments.json for tool calls.
   Keep service on 127.0.0.1. If harness runs elsewhere, explain routing limit and request approval
   before exposing service. A cloud harness cannot use my computer's localhost directly.
5. Create parametric OpenSCAD source under /workspace/models/<project>. Confirm dimensions, units, clearances, and print constraints. Render multiple views and inspect them. Export STL under /workspace/exports/<project>. Check dimensions, volume, and watertightness with MCP tools. Copy source, STL, and PNG previews to my computer. State print or physical checks still pending.
6. Report design files, desktop URL, MCP URL, setup results, design checks, and unresolved limits.
   Keep files in persistent workspace volume. Stop with docker compose down when requested.
   Never use docker compose down -v unless I explicitly request deletion of saved work.
```
