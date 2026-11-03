# Validation — 2026-10-14

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
