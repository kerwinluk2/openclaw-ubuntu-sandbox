# SECURITY

Security hardening for the OpenClaw Ubuntu Sandbox.

## Threat Model

This sandbox is designed to:
- Isolate OpenClaw, browser automation, and AI code tools from the host.
- Prevent privilege escalation if OpenClaw is compromised.
- Limit persistence and lateral movement.

## Hardening Measures

### Container Security

- **Non-root execution**: All services run as `sandbox` user (UID 1000).
- **Dropped capabilities**: `cap_drop: ["ALL"]` - no special privileges.
- **No new privileges**: `no-new-privileges:true` prevents setuid escalation.
- **Read-only root**: Root filesystem mounted read-only (`read_only: true`).
- **Limited writable paths**: Writable access is restricted to:
  - `/home/sandbox/.openclaw/workspace` (Project data)
  - `/home/sandbox/.config` & `.cache` (Browser sessions/app state)
  - `/home/sandbox/.npm` & `.ssh` (Dev tools)
  - `tmpfs` mounts for `/tmp`, `/run`, etc.

### Browser Automation & Shared Memory

- **Shared Memory**: `shm_size: 2gb` is enabled. 
  - *Reason*: Modern browsers (Chromium) require significant shared memory to render complex pages (like WhatsApp Web or Discord). Without this, tabs crash frequently ("Aw Snap").
- **Sandboxing**: Playwright is configured to run Chromium with `--no-sandbox`.
  - *Trade-off*: While `--no-sandbox` removes the internal Chrome sandbox layer, we rely on the outer **Docker container isolation** (namespaces, cgroups, dropped caps) for security. This allows us to keep `cap_drop: [ALL]` on the container itself, which is a stronger overall security posture than granting the container `SYS_ADMIN` capabilities just to run Chrome's internal sandbox.

### Resource Controls

- CPU limit: 4 cores
- Memory limit: 8GB
- Restart policy: unless-stopped

## Network Security

- Port 8080: noVNC web UI (requires browser access).
- Ports 18789/18790: OpenClaw API/WebSocket.

For production use, consider placing this container behind a reverse proxy with TLS (SSL) termination and authentication.

## Updating

Regularly rebuild to get security updates:
```bash
docker compose down
docker compose pull
docker compose build --no-cache
docker compose up -d
```
