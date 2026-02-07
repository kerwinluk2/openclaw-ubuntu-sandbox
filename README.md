# openclaw-ubuntu-sandbox

Hardened Ubuntu desktop sandbox for running OpenClaw inside Docker, exposed via noVNC on port 8080.

## Features

- Ubuntu 22.04 base with minimal desktop (XFCE) and noVNC.
- Non-root `sandbox` user, no-new-privileges, all Linux capabilities dropped.
- Read-only root filesystem with writable `data` directory only.
- Simple `docker compose` workflow for install and upgrades.

See `docs/INSTALL.md` to get started and `docs/SECURITY.md` for details of the hardening choices.
