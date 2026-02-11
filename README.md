# OpenClaw Ubuntu Sandbox

A hardened, secure Ubuntu desktop sandbox designed for running **OpenClaw** and **OpenCode AI** with full browser automation capabilities (Playwright/Chromium).

Designed for developers and automation engineers who need a safe, isolated environment that supports code development and complex browser tasks (WhatsApp, Telegram, Discord) without compromising host security.

## 🚀 Quick Start

### Windows PC (One-Click Install)

Run this command in **PowerShell**:

```powershell
irm https://raw.githubusercontent.com/kerwinluk2/openclaw-ubuntu-sandbox/main/install.ps1 | iex
```

**Requirements:**
- Docker Desktop installed and running ([Download here](https://docs.docker.com/desktop/install/windows-install/))
- Git installed (optional - only for cloning)

The script will automatically:
- Check prerequisites (Docker, Git)
- Clone or update the repository
- Build the Docker image
- Start the sandbox container

Once running, access the desktop at: **http://localhost:8080**

**Stop/Start commands:**
```powershell
# Navigate to the installation directory
cd ~\openclaw-sandbox\docker

# Stop the container
docker compose down

# Start the container
docker compose up -d
```

---

### Linux / VPS

Run this command on your Ubuntu server:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/kerwinluk2/openclaw-ubuntu-sandbox/main/install.sh)
```

*(This installs to `~/openclaw-sandbox` and starts the container)*

#### Connect from your Local Computer

The sandbox is locked down for security and blocks external connections by default. To access the desktop, run this secure tunnel command in a terminal on your **local computer**:

```bash
ssh -L 8080:127.0.0.1:8080 root@<YOUR_VPS_IP>
```

#### Open the Desktop

Open your browser and visit: **http://localhost:8080**

---

## ✨ Features

-   **🖥️ Web-based Desktop**: Full XFCE desktop environment accessible via browser (noVNC).
-   **🤖 AI Native**: Pre-configured for **OpenClaw** and **OpenCode AI** with optimized browser drivers.
-   **🔒 Hardened Security**:
    -   **Localhost Only**: No exposed ports to the internet. Access requires SSH tunneling.
    -   **Read-Only Root**: Prevents malware persistence and unauthorized system changes.
    -   **Non-Root User**: Runs as isolated `sandbox` user (UID 1000).
-   **🌐 Browser Automation**: Tuned Chromium with `playwright-extra`, shared memory tweaks, and stealth plugins.
-   **💾 Persistent Workspace**: Your code, sessions, and configs survive restarts (`~/openclaw-sandbox/data`).
-   **⚡ Developer Ready**: Includes Node.js 22, PHP, Composer, and git.

## 🛠️ Manual Installation

If you prefer to run it manually without the helper scripts:

```bash
# Clone into 'openclaw-sandbox' to match the automated installer
git clone https://github.com/kerwinluk2/openclaw-ubuntu-sandbox.git ~/openclaw-sandbox
cd ~/openclaw-sandbox/docker

# Build the image
docker compose build

# Start the container
docker compose up -d
```

## 📂 Documentation

-   [**Installation Guide**](docs/INSTALL.md): Detailed setup instructions and how to install OpenClaw plugins.
-   [**Security Model**](docs/SECURITY.md): Explanation of hardening measures, threat model, and trade-offs.
-   [**Hardening Details**](hardening/README.md): Custom seccomp profiles and advanced configuration.

## 🔌 Access & Ports

Services are bound to **127.0.0.1** for security.

| Port | Service | URL | Description |
| :--- | :--- | :--- | :--- |
| **8080** | noVNC | `http://localhost:8080` | Web-based Desktop Access |
| **18789** | OpenClaw API | `http://localhost:18789` | Main Automation Gateway |
| **18790** | OpenClaw WS | `http://localhost:18790` | WebSocket / Dashboard |

## 🛡️ Security Note

This sandbox balances strict security with usability. While it drops all capabilities and runs read-only, it enables specific features (like shared memory and specific writable volumes) to allow modern browsers and development tools to function correctly. See [SECURITY.md](docs/SECURITY.md) for full details.
