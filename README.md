# OpenClaw Ubuntu Sandbox

A hardened, secure Ubuntu desktop sandbox designed for running **OpenClaw** and **OpenCode AI** with full browser automation capabilities (Playwright/Chromium).

Designed for developers and automation engineers who need a safe, isolated environment that supports code development and complex browser tasks (WhatsApp, Telegram, Discord) without compromising host security.

## 🚀 Quick Start

### Linux / macOS
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/kerwinluk2/openclaw-ubuntu-sandbox/main/install.sh)
```

### Windows (PowerShell)
```powershell
irm https://raw.githubusercontent.com/kerwinluk2/openclaw-ubuntu-sandbox/main/install.ps1 | iex
```

This will:
1.  Clone (or update) this repository.
2.  Build the hardened Docker image.
3.  Start the sandbox.

---

## ✨ Features

-   **Full Desktop Environment**: XFCE desktop accessible via web browser (noVNC) at `http://localhost:8080`.
-   **AI Automation Ready**: Pre-installed with **OpenClaw (v2026.2.3)**, **OpenCode AI**, and **Playwright**.
-   **Browser Automation**: Optimized for Chromium automation (WhatsApp, Telegram, Discord, etc.) with shared memory tweaks and session persistence.
-   **Secure by Design**:
    -   **Non-root**: Runs entirely as user `sandbox` (UID 1000).
    -   **Read-Only Root**: The container's root filesystem is read-only.
    -   **Least Privilege**: All Linux capabilities dropped (`cap_drop: [ALL]`).
    -   **Isolation**: `no-new-privileges` enabled to prevent escalation.
-   **Persistent Workspace**: Keeps your projects, browser sessions (`.config`), SSH keys, and npm packages between restarts.

## 🛠️ Manual Installation

If you prefer to run it manually without the helper scripts:

```bash
git clone https://github.com/kerwinluk2/openclaw-ubuntu-sandbox.git
cd openclaw-ubuntu-sandbox/docker

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

| Port | Service | URL | Description |
| :--- | :--- | :--- | :--- |
| **8080** | noVNC | `http://localhost:8080` | Web-based Desktop Access |
| **18789** | OpenClaw API | `http://localhost:18789` | Main Automation Gateway |
| **18790** | OpenClaw WS | `http://localhost:18790` | WebSocket / Dashboard |

## 🛡️ Security Note

This sandbox balances strict security with usability. While it drops all capabilities and runs read-only, it enables specific features (like shared memory and specific writable volumes) to allow modern browsers and development tools to function correctly. See [SECURITY.md](docs/SECURITY.md) for full details.
