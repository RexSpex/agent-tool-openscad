# Validation

## 2026-11-03

[Linux amd64 workflow](https://github.com/RexSpex/agent-tool-openscad/actions/runs/41672495354) passes on Ubuntu 24.04.
Docker Desktop 4.91.0 (Docker Engine 29.8.0) on macOS Apple Silicon passes with native Linux arm64 image.

Both environments pass image build, healthy startup, desktop redirect, VNC handshake,
MCP discovery, OpenSCAD check, PNG rendering, STL export, and geometry checks.
Test cube measures 10 × 20 × 30 mm, volume 6000 cubic mm, with watertight mesh.
Model survives container recreation. Terminal MCP client connects and calls tools.
Local terminal client also reads persistent model and returns nonzero for missing tool.
Seven Python tests cover occupied ports, settings preservation, CPU adaptation,
JSON/SSE negotiation, sessions, nested tool errors, and local image artifacts.

Default host port is 48321. Setup selects another free port when occupied,
saves selected port in .env, and caps CPU limit to available Docker CPUs.
Software renderer uses 2 threads to avoid observed crashes under renderer memory cap on high-core hosts.
`CAD_SOFTWARE_THREADS` controls Mesa [LP_NUM_THREADS](https://docs.mesa3d.org/envvars.html#lp-num-threads).
Container port remains 8080. Build needs at least 12 GiB free host disk.
A separate local setup with ports 48321 and 48322 occupied selects 48323 and passes smoke checks.

Native harness configuration remains client-specific. Terminal MCP client is tested.
Windows is not tested. Physical print quality is not established by geometry checks.

## Earlier validation — 2026-10-14

Portable image builds on Linux amd64 with Docker 29.8.2.

Default Compose configuration is inspected: one service, host loopback port,
named volumes, no host paths, and no external ingress network.
A separate Compose project starts with new named volumes and becomes healthy.
No production container or production workspace is used for these tests.

`tests/smoke.py` passes:

- Root redirect preserves origin and reaches noVNC on same host and port.
- Desktop HTTP returns 200.
- VNC WebSocket returns 101 and RFB 003.008 handshake.
- MCP initialization and tool discovery succeed.
- OpenSCAD installation check succeeds.
- Model creation, PNG rendering, and STL export succeed.
- Exported 10 × 20 × 30 mm cube measures 6000 cubic mm and is watertight.

Compose recreates container using same volumes and waits for healthy state.
Smoke test finds previous model and passes again. Volumes survive recreation.

Compose configuration parses with Docker Compose CLI.
Python healthcheck and smoke scripts compile. Source scan finds no credential
markers. Vendored upstream copyright and MIT license remain intact.

Docker Desktop on macOS/Windows and native Linux arm64 are not tested.
No architecture is forced in Dockerfile or Compose. Native arm64 build depends
on upstream package availability. Host reboot and restoration from backup are
not tested. Docker Desktop requires Linux containers and enough memory.
