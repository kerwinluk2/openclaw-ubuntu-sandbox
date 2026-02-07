# INSTALL

Hardened Ubuntu desktop sandbox with OpenClaw, OpenCode AI, and browser automation.

## Prerequisites

- Docker Engine 20.10+ with Docker Compose plugin
- Linux host with at least 8GB RAM and 4 CPU cores recommended

## Quick Start

```bash
# Clone the repository
git clone https://github.com/kerwinluk2/openclaw-ubuntu-sandbox.git
cd openclaw-ubuntu-sandbox/docker

# Build the image
docker compose build

# Start the sandbox
docker compose up -d

# Access the desktop via noVNC
# Open: http://localhost:8080

# View logs
docker compose logs -f
```

## What’s Included

- **Desktop Environment**: XFCE accessible via noVNC on port 8080
- **OpenClaw** (v2026.2.3): AI automation platform running on ports 18789/18790
- **OpenCode AI**: Code development assistant
- **Browser Automation**: Playwright with Chromium for web control
- **Development Tools**: Node.js 22, Python 3, Git, jq

## Using OpenClaw

Once the container is running:

1. Open `http://localhost:8080` to access the desktop via noVNC
2. OpenClaw runs automatically - it can control the browser and perform tasks
3. OpenCode AI runs in the background for code assistance

### Install Additional Plugins

Enter the container and install plugins:

```bash
docker exec -it openclaw-sandbox bash
openclaw plugins install <plugin-name>
```

Popular plugins from the reference repo:
- `@m1heng-clawd/feishu` - Feishu integration
- `openclaw-plugin-wecom` - WeChat Work integration

## Security

- Runs as non-root `sandbox` user (UID 1000)
- Read-only root filesystem with limited writable paths
- All Linux capabilities dropped
- `no-new-privileges` enabled
- Resource limits: 4 CPUs, 8GB RAM

## Workspace Persistence

Your OpenClaw workspace and projects are stored in `./data/` on the host:

- `./data/` → `/home/sandbox/.openclaw/workspace`
- `./data/.gitconfig` → Git configuration
- `./data/.npm` → npm cache
