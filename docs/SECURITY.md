# SECURITY

Security hardening for the OpenClaw Ubuntu Sandbox.

## Threat Model

This sandbox is designed to:
- Isolate OpenClaw, browser automation, and AI code tools from the host
- Prevent privilege escalation if OpenClaw is compromised
- Limit persistence and lateral movement

## Hardening Measures

### Container Security

- **Non-root execution**: All services run as `sandbox` user (UID 1000)
- **Dropped capabilities**: `cap_drop: ["ALL"]` - no special privileges
- **No new privileges**: `no-new-privileges:true` prevents setuid escalation
- **Read-only root**: Root filesystem mounted read-only
- **Limited writable paths**: Only `/home/sandbox/.openclaw/workspace` and tmpfs mounts are writable

### Resource Controls

- CPU limit: 4 cores
- Memory limit: 8GB
- Restart policy: unless-stopped

### Browser/Chromium Security

Playwright runs Chromium in sandbox mode. The container requires:
- User namespace support on the host Docker daemon
- Proper seccomp profile (Docker default is applied)

If you encounter Chromium sandbox issues, you can add the host's Chrome sandbox:
```bash
# Add to docker-compose.yml security_opt:
- seccomp:unconfined  # Only if necessary, reduces security
```

## Network Security

- Port 8080: noVNC web UI (requires browser access)
- Ports 18789/18790: OpenClaw API/WebSocket

Consider placing behind a reverse proxy with TLS for production use.

## Updating

Regularly rebuild to get security updates:
```bash
docker compose down
docker compose pull
docker compose build --no-cache
docker compose up -d
```
